{ sshConfig, sshKeys }: { config, pkgs, lib, ... }:

{
  home.activation = {
    activationExample = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD echo placeholder
    '';
  };

  home.packages = [
    pkgs.google-cloud-sql-proxy
    pkgs.dos2unix
    pkgs.gcc
    pkgs.gnumake
    (pkgs.google-cloud-sdk.withExtraComponents
      [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    pkgs.cargo
    pkgs.htop
    pkgs.gh
    pkgs.ispell
    pkgs.jq
    pkgs.killall
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.libvterm-neovim
    pkgs.lsof
    pkgs.mc
    pkgs.moreutils
    pkgs.nix-prefetch-git
    pkgs.nixfmt
    pkgs.nixpkgs-fmt
    pkgs.nodejs
    pkgs.nurl
    (lib.hiPrio pkgs.parallel)
    pkgs.postgresql
    pkgs.python39
    pkgs.ripgrep
    pkgs.silver-searcher
    pkgs.sqlite.dev
    pkgs.tree
    pkgs.watch
    pkgs.wget
    pkgs.xclip
    pkgs.xmlstarlet
    pkgs.xsel
    pkgs.yq-go
  ];

  home.sessionVariables = { EDITOR = "vim"; };

  home.sessionPath = [ "/usr/local/bin" ];

  home.file.".emacs.d" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "syl20bnr";
      repo = "spacemacs";
      # sha256 = pkgs.lib.fakeHash;
      rev = "4a227fc94651136a8de54bcafa7d22abe1fa0295";
      sha256 = "sha256-+pvgf+oWJQZbcvoTbQQKnQy/1X4mxtSxFdUjpfqv1f0=";
      # date = "2022-09-13T18:44:48-04:00";

    };
  };

  home.file.".spacemacs.d" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/config-nix/dotfiles/spacemacs.d";
  };

  home.file.".authinfo.gpg" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/config-nix-private/dotfiles/authinfo.gpg";
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
      init = { defaultBranch = "main"; };
    };
  };

  programs.gpg = {
    enable = true;
    settings = { no-symkey-cache = false; };
  };

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = [ "FE09FD0729375918" ] ++ sshKeys;
    agents = [ "ssh" "gpg" ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
      vim-surround
      nerdtree
      NeoSolarized
      vim-nix
      vim-airline
      vim-airline-themes
      vimagit
    ];
    extraConfig = ''
      set encoding=utf8

      let g:airline_powerline_fonts = 1

      set list

      filetype plugin indent on
      set autoindent

      set backspace=indent,eol,start
      set hidden
      set number

      set ignorecase
      set smartcase

      set incsearch
      set hlsearch

      set termguicolors
      colorscheme NeoSolarized
      let g:neosolarized_contrast = "high"

      let mapleader = "\<Space>"
      vmap s S

      nmap <leader>sc :noh<CR>
      nmap <leader>pt :NERDTreeToggle<CR>

      nmap <leader>wl :TmuxNavigateRight<CR>
      nmap <leader>wh :TmuxNavigateLeft<CR>
      nmap <leader>wj :TmuxNavigateDown<CR>
      nmap <leader>wk :TmuxNavigateUp<CR>

      nmap <leader>gs :Magit<CR>

      command W :w
    '';
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
      nrl = "direnv reload && nix-direnv-reload";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
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
}
