config-nix-private:
let
  darwinOpts = {
    hostName = "marco";
    nixbldGid = 30000;
    manageNix = true;
  };
in
{

  homeConfig = {
    homeDirectory = "/Users/dave";
    stateVersion = "22.05";
    system = "aarch64-darwin";
    defaultGithubUser = "actionshrimp";
    homeModules = [
      ../../home/darwin
      (
        { config, lib, ... }:
        {
          # localhost:8384
          services.syncthing.enable = true;
          programs.ssh.matchBlocks = config-nix-private.sshConfig.personal;
          programs.keychain.keys = lib.mkAfter [
            "0x3F92E3893C4349DD"
          ];
          home.sessionVariables = config-nix-private.additionalSessionVariables.personal;
          home.packages = lib.mkAfter [ ];
        }
      )
    ];
  };
  darwinModules = [
    (import ../../system/common.nix)
    (import ../../system/darwin/darwin-configuration.nix darwinOpts)
    (
      { lib, ... }:
      {
        homebrew.brews = lib.mkAfter [
          "cocoapods"
          "watchman"
        ];
        homebrew.casks = lib.mkAfter [
          "android-studio"
          "zulu@17"
        ];
        homebrew.taps = lib.mkAfter [ ];
      }
    )
  ];
}
