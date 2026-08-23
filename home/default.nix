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
    awscli2
    bash-language-server
    bun
    cargo
    rustc
    cpulimit
    devenv
    dos2unix
    entr
    emacs
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
    jre
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
    lua
    mc
    mkcert

    moreutils
    ncdu
    nil
    nix-output-monitor
    nix-prefetch-git
    nixd
    nixfmt
    nixpkgs-fmt
    vscode-json-languageserver
    nodejs_22
    nurl
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
    tree-sitter # required by nvim-treesitter (main branch) to build parsers
    typos
    typescript-language-server
    vscode-js-debug
    watch
    watchexec
    worktrunk
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
    JAVA_HOME = "${pkgs.jre}";
  };

  home.sessionPath = [
    "/usr/local/bin"
    "${config.home.homeDirectory}/config-nix/dotfiles/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

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
      # Per-worktree agent-instruction symlinks created by worktrunk hooks
      "CLAUDE.local.md"
      "AGENTS.local.md"
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
      rebase.autoStash = true;
      user = {
        name = "Dave Aitken";
        email = "dave.aitken@gmail.com";
        # SSH commit signing with the single actionshrimp key
        signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
      gpg.format = "ssh";
      commit.gpgSign = true;
      github.user = "actionshrimp";
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
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    # New default since 26.05; nothing here uses the Ruby provider.
    withRuby = false;
  };

  # The whole ~/.config/nvim is an out-of-store symlink to dotfiles below, so
  # home-manager's generated init.lua never took effect anyway. Since 26.05 the
  # file installer resolves it through the symlink and refuses it as being
  # outside $HOME, so turn it off explicitly.
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/config/nvim";
  };

  home.file.".wezterm.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/wezterm.lua";
  };

  # ~/.config/herdr is herdr's own state directory (sockets, logs, session.json,
  # plugins.json), so link the config file in on its own rather than symlinking
  # the directory. The ctrl+h/j/k/l bindings in there point at the herdr plugin
  # shipped with smart-splits.nvim, which needs a one-time registration:
  #   herdr plugin link ~/.local/share/nvim/lazy/smart-splits.nvim
  # That writes to plugins.json, which stays out of this repo as runtime state.
  home.file.".config/herdr/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/config/herdr/config.toml";
  };

  # ~/.claude holds a lot of runtime state (projects, sessions, plugins), so
  # link the config in file by file rather than symlinking the whole directory.
  # That keeps the state out of this repo and, since ~/.claude stays a real
  # directory, lets home-manager manage individual entries inside it — which is
  # how config-nix-private contributes the work skills.
  home.file.".claude/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/claude/settings.json";
  };

  home.file.".claude/statusline.sh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/claude/statusline.sh";
  };

  # Every skill directory in dotfiles/claude/skills, linked out of the live
  # checkout so edits apply without a rebuild. Adding one needs no change here.
  # Generated as its own module so it can merge with the home.file entries
  # written out longhand above.
  imports = [
    (
      { ... }:
      {
        home.file = lib.listToAttrs (
          map (
            name:
            lib.nameValuePair ".claude/skills/${name}" {
              source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/claude/skills/${name}";
            }
          ) (lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../dotfiles/claude/skills)))
        );
      }
    )
  ];

  home.file.".pi" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/pi";
  };

  home.file.".config/direnv/direnvrc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/config/direnv/direnvrc";
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
    # `matchBlocks` (and its camelCase keys) is deprecated in favour of
    # `settings`, which takes upstream ssh_config(5) directive names verbatim.
    settings."*" = {
      AddKeysToAgent = "yes";
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
    # Always use the cached dump (-C) and skip the security audit. The audit
    # stats the entire nix-store fpath on every shell start, adding ~1.8s to
    # startup. Trade-off: newly-added completions won't appear until the dump is
    # rebuilt manually (run `compinit` or `rm ~/.zcompdump`). The activation
    # script below reminds you of this after a switch.
    completionInit = ''
      autoload -Uz compinit
      compinit -C
    '';
    defaultKeymap = "viins";
    shellAliases = {
      nu = "vim ~/config-nix/hosts/home-common.nix";
      k = "kubectl";
      wk = "watch kubectl";
      kc = "kubectl config use-context";
      kcc = "kubectl config current-context";
      gbi = "git config --local blame.ignoreRevsFile .git-blame-ignore-revs";
      nrl = "direnv reload && nix-direnv-reload |& nom --json";
      k9sc = "k9s -c context";
      pr = "review-pr";
      # granted's `assume` must be sourced so it can export AWS creds into the
      # current shell; it normally appends this alias to ~/.zshrc, but that's
      # nix-managed/read-only, so we declare it here instead.
      assume = "source assume";
      tt = "zellij action rename-tab";
      clc = "if [ -n \"$ZELLIJ\" ]; then zelcld --dangerously-skip-permissions; else claude --dangerously-skip-permissions; fi";
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

      # worktrunk (wt) shell integration: wraps `wt` so it can cd/exec in the
      # current shell (see `wt config shell`). Generated at build time from the
      # packaged binary so it stays in sync with the installed version without
      # spawning `wt` on every shell startup.
      source ${
        pkgs.runCommand "wt-shell-init.zsh" { } ''
          ${pkgs.worktrunk}/bin/wt config shell init zsh > $out
        ''
      }

      # nvm is installed via Homebrew, so nvm.sh lives under the brew prefix
      # rather than $NVM_DIR/nvm.sh. NVM_DIR still points at ~/.nvm where nvm
      # installs the node versions it manages.
      export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

    '';
  };

  # zsh startup uses `compinit -C` (see programs.zsh.completionInit) which loads
  # the cached completion dump without rescanning fpath. If a switch adds new
  # completions they won't show up until the dump is rebuilt, so remind us.
  home.activation.compinitReminder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo ""
    echo "NOTE: zsh uses a cached completion dump (compinit -C) for fast startup."
    echo "      If completions were added, run 'compinit' or 'rm ~/.zcompdump' in a"
    echo "      new shell to pick them up."
    echo ""
  '';

  nixpkgs.overlays = homeOverlays;
  nixpkgs.config.allowUnfree = true;
}
