{ hostName
, homebrewCasks
}: { pkgs, nix, nixpkgs, config, lib, ... }: {

  users = { users.dave = { home = "/Users/dave"; }; };

  networking.hostName = hostName;

  services.nix-daemon.enable = true;

  # nb: for aarch64-linux only at present sadly (and not x64_64-linux)
  nix.linux-builder = {
    enable = false;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 6;
      };
    };
  };

  nix.settings.trusted-users = [ "@admin" ];

  system.defaults = {
    NSGlobalDomain.InitialKeyRepeat = 20;
    NSGlobalDomain.KeyRepeat = 1;
    dock.autohide = true;
    dock.autohide-time-modifier = 0.4;
    dock.autohide-delay = 1000.0;
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      "homebrew/cask-fonts"
      # "d12frosted/emacs-plus
    ];
    brews = [
      # "d12frosted/emacs-plus/emacs-plus@29"
    ];
    casks = [
      "maccy"
      "font-jetbrains-mono-nerd-font"
    ] ++ homebrewCasks;
  };
}
