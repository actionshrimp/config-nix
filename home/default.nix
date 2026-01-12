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
    entr
    fd
    fswatch
    gh
    gnumake
    # (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    # google-cloud-sql-proxy
    helm-ls
    htop
    ispell
    imagemagick
    ghostscript
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
    nodejs_22
    nurl
    ollama
    (lib.hiPrio parallel)
    postgresql
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
    vscode-js-debug
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
    settings = {
      # swapped in favour of `gbi` alias below
      # blame = { ignoreRevsFile = ".git-blame-ignore-revs"; };
      init = {
        defaultBranch = "main";
      };
      core = {
        attributesfile = "~/.gitattributes";
      };
      fetch = {
        # A value of 0 will give some reasonable default, if unset it defaults to 1.
        parallel = 0;
      };
      safe = {
        directory = "/Users/dave/dev/gn/goodnotes-5";
      };
      diff = {
        image = {
          command = "~/.local/bin/git-diff-image";
        };
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

  home.file.".gitattributes" = {
    text = ''
      *.png diff=image
    '';
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

  home.file.".config/git/config.actionshrimp" =
    let
      signingKey =
        if homeConfig.defaultGithubUser == "gn-dave-a" then "0x4C030895BE1EEBE1" else "0xFE09FD0729375918";
    in
    {
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
            signingkey = ${signingKey}
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

  home.file.".local/bin/git-diff-image" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/bin/git-diff-image";
  };

  home.file.".config/ghostty/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/config/ghostty/config";
  };

  home.file.".config/zellij" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/config/zellij";
  };

  # programs.opam = {
  #   enable = true;
  #   enableZshIntegration = true;
  # };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      extraOptions = {
        UseKeychain = "yes";
      };
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

  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
    enableAliases = true;
    options = [
      "enhanced"
      "once"
      "fzf"
    ];
  };

  programs.zellij = {
    enable = true;
    # enableZshIntegration = true;
    # settings moved to dotfiles/config/zellij/config.kdl
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
      pr = "review-pr";
      wt = "wezterm cli set-tab-title";
      tt = "zellij action rename-tab";
    };
    history = {
      size = 10000000;
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

      review-pr() {
        git fetch origin
        nvim -c ":DiffviewOpen origin/develop...origin/$1"
      }

      diff-screenshots() {
        compare "$1" "$2" -compose src diff.png
      }

      watch-xps() {
        find .. \( -path '../Crossplatform/*' -or -path '../CommonSwift/*' \) -and -name '*.swift' -and -not -path '*.build*' | entr -rcs 'echo Reloading; echo; ./scripts/updateWasmModule.sh debug'
      }

      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    '';
  };

  nixpkgs.overlays = homeOverlays;
  nixpkgs.config.allowUnfree = true;
}
