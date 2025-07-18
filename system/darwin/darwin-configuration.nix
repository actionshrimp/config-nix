{
  hostName,
  nixbldGid ? 350,
  ...
}:
{
  pkgs,
  nix,
  nixpkgs,
  config,
  lib,
  ...
}:
{

  system.stateVersion = 5;

  users = {
    users.dave = {
      home = "/Users/dave";
    };
  };

  networking.hostName = hostName;

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

  # ideally this would be removed for new installations
  ids.gids.nixbld = nixbldGid;

  nix.nixPath = [ { nixpkgs = "${nixpkgs}"; } ];

  # Using determinate nix instead
  nix.enable = false;

  system.primaryUser = "dave";
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
    ];
    brews = [
    ];
    casks = [
      "maccy"
      "font-jetbrains-mono-nerd-font"
      "nuage" # soundcloud native app
    ];
  };
}
