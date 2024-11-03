{
  homeOverlays,
  homeDirectory,
  stateVersion,
  sshConfig,
  sshKeys,
  apiKeys,
}:
{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.activation = {
    spacemacs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD [ ! -d ~/.emacs.d ] && git clone git@github.com:syl20bnr/spacemacs.git ~/.emacs.d
      $DRY_RUN_CMD cd ~/.emacs.d && git fetch && git reset --hard 4a227fc94651136a8de54bcafa7d22abe1fa0295
    '';
  };

  # completion should work in here thanks to "with pkgs;"
  home.packages = with pkgs; [
    awscli2
    google-cloud-sql-proxy
    dos2unix
    gnumake
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    cargo
    htop
    fd
    gh
    helm-ls
    ispell
    jq
    jnettop
    k9s
    killall
    kubectl
    kubernetes-helm
    ollama
    lazygit
    lua-language-server
    luajitPackages.luarocks
    libvterm-neovim
    lsof
    mc
    moreutils
    ncdu
    nil
    nixd
    nix-prefetch-git
    nix-output-monitor
    nixfmt-classic
    nixpkgs-fmt
    nodejs
    nodePackages.vscode-json-languageserver
    nurl
    (lib.hiPrio parallel)
    postgresql
    python39
    realvnc-vnc-viewer
    ripgrep
    silver-searcher
    tailwindcss-language-server
    shellcheck
    bash-language-server
    sqlite.dev
    stylua
    selene
    tree
    typos
    watch
    wezterm
    wget
    xclip
    xmlstarlet
    xsel
    yq-go
  ];

  home.sessionVariables = ({
    EDITOR = "vim";
  });

  home.sessionPath = [ "/usr/local/bin" ];

  home.file.".spacemacs.d" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/spacemacs.d";
  };

  home.file.".authinfo.gpg" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix-private/dotfiles/authinfo.gpg";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Dave Aitken";
    userEmail = "dave.aitken@gmail.com";
    signing = {
      signByDefault = true;
      key = "EDB3240E95F9F2B8A24251AAFE09FD0729375918";
    };
    ignores = [ ".DS_Store" ];
    extraConfig = {
      # swapped in favour of `gbi` alias below
      # blame = { ignoreRevsFile = ".git-blame-ignore-revs"; };
      init = {
        defaultBranch = "main";
      };
      fetch = {
        # A value of 0 wiill give some reasonable default, if unset it defaults to 1.
        parallel = 0;
      };
    };
  };

  programs.gpg = {
    enable = true;
    settings = {
      no-symkey-cache = false;
    };
  };

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = [ "FE09FD0729375918" ] ++ sshKeys;
    agents = [
      "ssh"
      "gpg"
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
  };

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/config/nvim";
  };

  home.file.".wezterm.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/wezterm.lua";
  };

  programs.opam = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ssh = {
    enable = true;
    matchBlocks = sshConfig;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      time.disabled = false;
      add_newline = false;
      line_break.disabled = true;
      aws.disabled = true;
      docker_context.disabled = true;
      git_branch.disabled = true;
      git_status.disabled = true;
      nix_shell.disabled = true;
      ocaml.disabled = true;
      nodejs.disabled = true;
      python.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = true;
      rust.disabled = true;
      package.disabled = true;
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "screen-256color";
    escapeTime = 30;
    historyLimit = 20000;
    plugins = with pkgs.tmuxPlugins; [
      cpu
      power-theme
      yank
      vim-tmux-navigator
    ];
    extraConfig = ''
      unbind-key c
      bind-key c new-window -c "#{pane_current_path}"
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi Escape send -X clear-selection
      bind ^B last-window
      unbind-key %
      bind-key v split-window -h -c "#{pane_current_path}"
      unbind-key '"'
      unbind-key s
      bind-key s split-window -c "#{pane_current_path}"
      bind-key '"' choose-session
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    shellAliases = {
      nu = "vim ~/config-nix/hosts/home-common.nix";
      k = "kubectl";
      wk = "watch kubectl";
      kc = "kubectl config use-context";
      kcc = "kubectl config current-context";
      gbi = "git config --local blame.ignoreRevsFile .git-blame-ignore-revs";
      nrl = "direnv reload && nix-direnv-reload |& nom --json";
      iw = "cd ~/dev/ai/imandra-web";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra =
      ''
        autoload -z edit-command-line

        zle -N edit-command-line
        bindkey -M vicmd v edit-command-line

        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        compdef __start_kubectl k
        compdef __start_kubectl wk

        export LESS="R"

        # insert the last arg of the previous command when you press Esc-. in insert mode
        bindkey -M viins '\e.' insert-last-word

        # shift+tab goes back one on tab completion
        bindkey '^[[Z' reverse-menu-complete

        if [ -n "''${TMUX}" ]; then
          #inside tmux
          bindkey "^[[1~" beginning-of-line
          bindkey "^[[3~" delete-char
          bindkey "^[[4~" end-of-line

          bindkey -M vicmd "^[[1~" vi-beginning-of-line
          bindkey -M vicmd "^[[3~" vi-delete-char
          bindkey -M vicmd "^[[4~" vi-end-of-line
        else
          #outside tmux
          bindkey "^[OH" beginning-of-line
          bindkey "^[OF" end-of-line
          bindkey "^[[3~" delete-char

          bindkey -M vicmd "^[OH" vi-beginning-of-line
          bindkey -M vicmd "^[OF" vi-end-of-line
          bindkey -M vicmd "^[[3~" vi-delete-char

        fi

        date-ts() {
          date $@ --rfc-3339=seconds | sed 's/ /T/'
        }

        gc-pod-log() {
          if [ -z "$1" ] || [ -z "$2" ]; then
            echo "Usage: gc-pod-log PROJECT_ID POD_ID [START_TIMESTAMP:$(date-ts --date "1 day ago")]"
            return 1
          fi

          local DEFAULT_TS=$(date-ts --date "1 day ago")
          local TS="''${3:-$DEFAULT_TS}"
          local QUERY="resource.labels.pod_name=''${2} AND timestamp>=\"''${TS}\""
          gcloud --project "$1" \
              logging read "$QUERY" \
              --format='value(receiveTimestamp, firstof(textPayload, jsonPayload.message))' \
              --order asc
        }

        my-ip() {
          curl -s ifconfig.co
        }

      ''
      + pkgs.lib.strings.concatLines (
        (if apiKeys ? openAi then [ "export OPENAI_API_KEY=${apiKeys.openAi}" ] else [ ])
        ++ (if apiKeys ? anthropic then [ "export ANTHROPIC_API_KEY=${apiKeys.anthropic}" ] else [ ])
      );
  };

  nixpkgs.overlays = homeOverlays;
  nixpkgs.config.allowUnfree = true;
}
