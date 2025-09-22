{ pkgs, config, ... }:
{

  home.packages = [
    pkgs.tree
    pkgs.coreutils
    pkgs.pinentry_mac
    pkgs.iterm2
    pkgs.stats

    # Alias sed to gsed to appease macos programs that expect gsed as gsed (nvim-spectre) -_-
    (pkgs.buildEnv {
      name = "symlink-gsed";
      paths = [
        pkgs.gnused
        (pkgs.runCommand "symlink-gsed" { } ''
          mkdir -p $out/bin
          ln -s ${pkgs.gnused}/bin/sed $out/bin/gsed
        '')
      ];
    })
  ];

  home.sessionPath = [ "/opt/homebrew/bin" ];

  programs.zsh = {
    initContent = ''
      ulimit -n 99999

      vnodes() {
        echo $(sudo sysctl kern.num_vnodes) / $(sudo sysctl kern.maxvnodes)
      }

      mksudo() {
        MINS="''${1:-5}"
        SECS=$(( $MINS * 60 ))
        echo Temporarily granting sudo access to $USER for "$MINS"m...
        DOREVOKE="echo Revoking... && dseditgroup -o edit -d $USER -t user admin && echo Revoked."
        DOGRANT="dseditgroup -o edit -a $USER -t user admin && echo Granted."
        su admin -c "sudo bash -c \"trap \\\"$DOREVOKE\\\" EXIT && "$DOGRANT" && sleep $SECS\""
      }
    '';
  };

  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    userSettings = {
      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-w = "close";
        alt-n = "focus-monitor next";
        alt-p = "focus-monitor prev";
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        # alt-3 = "workspace 3"; conflicts with # symbol...
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
        alt-keypad1 = "workspace 1";
        alt-keypad2 = "workspace 2";
        alt-keypad3 = "workspace 3";
        alt-keypad4 = "workspace 4";
        alt-keypad5 = "workspace 5";
        alt-keypad6 = "workspace 6";
        alt-keypad7 = "workspace 7";
        alt-keypad8 = "workspace 8";
        alt-keypad9 = "workspace 9";
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
        alt-shift-keypad1 = "move-node-to-workspace 1";
        alt-shift-keypad2 = "move-node-to-workspace 2";
        alt-shift-keypad3 = "move-node-to-workspace 3";
        alt-shift-keypad4 = "move-node-to-workspace 4";
        alt-shift-keypad5 = "move-node-to-workspace 5";
        alt-shift-keypad6 = "move-node-to-workspace 6";
        alt-shift-keypad7 = "move-node-to-workspace 7";
        alt-shift-keypad8 = "move-node-to-workspace 8";
        alt-shift-keypad9 = "move-node-to-workspace 9";
        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";
      };
      workspace-to-monitor-force-assignment = {
        "1" = "built-in";
        "2" = "built-in";
        "3" = "built-in";
        "4" = [
          "lg hdr 4k"
          "dell"
        ];
        "5" = [
          "lg hdr 4k"
          "dell"
        ];
        "6" = [
          "lg hdr 4k"
          "dell"
        ];
        "7" = [
          "27gl850"
          "dell"
        ];

        "8" = [
          "27gl850"
          "dell"
        ];
        "9" = [
          "27gl850"
          "dell"
        ];
      };
      on-focused-monitor-changed = [ ];
    };
  };

  # programs.sketchybar = {
  #   enable = true;
  # };
  #
  # home.file.".config/sketchybar" = {
  #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config-nix/dotfiles/config/sketchybar";
  # };
}
