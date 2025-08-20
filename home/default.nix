{
  homeConfig,
  homeOverlays,
}:
{
  config,
  pkgs,
  lib,
  ...
}:

{
  # completion should work in here thanks to "with pkgs;"
  home.packages = with pkgs; [
    aider-chat
    awscli2
    bash-language-server
    cargo
    devenv
    dos2unix
    fd
    fswatch
    gh
    gnumake
    # (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    # google-cloud-sql-proxy
    helm-ls
    htop
    ispell
    jnettop
    jq
    k9s
    killall
    kubectl
    kubernetes-helm
    lazygit
    libvterm-neovim
    lsof
    lua-language-server
    luajitPackages.luarocks
    mc
    mkcert
    moreutils
    ncdu
    nil
    nix-output-monitor
    nix-prefetch-git
    nixd
    nixfmt-classic
    nixpkgs-fmt
    nodePackages.vscode-json-languageserver
    nodejs
    nurl
    ollama
    (lib.hiPrio parallel)
    postgresql
    pnpm
    python3Full
    uv
    ripgrep
    ruby
    selene
    shellcheck
    silver-searcher
    socat
    sqlite.dev
    stylua
    # tailwindcss-language-server - moved to brew
    terraform-lsp
    tflint
    tree
    typos
    typescript-language-server
    watch
    # wezterm - moved to brew
    wget
    xclip
    xmlstarlet
    xsel
    yq-go
    noto-fonts
    noto-fonts-cjk-sans
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.sessionPath = [ "/usr/local/bin" ];

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
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
    ignores = [
      ".DS_Store"
      ".ignore"
    ];
    lfs.enable = true;
    extraConfig = {
      # swapped in favour of `gbi` alias below
      # blame = { ignoreRevsFile = ".git-blame-ignore-revs"; };
      init = {
        defaultBranch = "main";
      };
      fetch = {
        # A value of 0 will give some reasonable default, if unset it defaults to 1.
        parallel = 0;
      };
      safe = {
        directory = "/Users/dave/dev/gn/goodnotes-5";
      };
      rebase.autoStash = true;
    };
    includes = (
      if homeConfig.defaultGithubUser == "gn-dave-a" then
        [
          {
            path = "${config.home.homeDirectory}/.config/git/config.gn-dave-a";
          }
          {
            path = "${config.home.homeDirectory}/.config/git/config.actionshrimp";
            condition = "gitdir:~/dev/nvim/";
          }
          {
            path = "${config.home.homeDirectory}/.config/git/config.actionshrimp";
            condition = "gitdir:~/dev/actionshrimp/";
          }
          {
            path = "${config.home.homeDirectory}/.config/git/config.actionshrimp";
            condition = "gitdir:~/config-nix/";
          }
          {
            path = "${config.home.homeDirectory}/.config/git/config.actionshrimp";
            condition = "gitdir:~/config-nix-private/";
          }
        ]
      else
        [
          {
            path = "${config.home.homeDirectory}/.config/git/config.actionshrimp";
          }
        ]
    );
  };

  home.file.".config/git/config.gn-dave-a" = {
    text = ''
      [commit]
          gpgSign = true
      [core]
          sshCommand = ssh -i ${config.home.homeDirectory}/.ssh/gn-dave-a.id_ed25519 -o IdentityAgent=none
      [github]
          user = gn-dave-a
      [gpg]
          program = gpg
          format = openpgp
      [user]
          name = Dave Aitken
          email = dave.a@goodnotes.com
          signingkey = 3F92E3893C4349DD
    '';
  };

  home.file.".config/git/config.actionshrimp" = {
    text = ''
      [commit]
          gpgSign = true
      [core]
          sshCommand = ssh -i ${config.home.homeDirectory}/.ssh/actionshrimp.id_ed25519 -o IdentityAgent=none
      [github]
          user = actionshrimp
      [gpg]
          program = gpg
          format = openpgp
      [user]
          name = Dave Aitken
          email = dave.aitken@gmail.com
          signingkey = 0x4C030895BE1EEBE1
    '';
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
    agents = [
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

  # programs.opam = {
  #   enable = true;
  #   enableZshIntegration = true;
  # };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraOptionOverrides = {
      UseKeychain = "yes";
    };
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
      bind -n 'C-\' if-shell "$is_vim" "send-keys 'C-\\'" "select-pane -l"
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
      gn = "cd ~/dev/gn/goodnotes-5";
      k9sc = "k9s -c context";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = ''
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
    '';
  };

  nixpkgs.overlays = homeOverlays;
  nixpkgs.config.allowUnfree = true;
}
