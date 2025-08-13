config-nix-private:
let
  darwinOpts = {
    hostName = "daves-macbook";
    ## Remove for new systems
    nixbldGid = 30000;
  };
in
{
  homeConfig = {
    homeDirectory = "/Users/dave";
    stateVersion = "22.05";
    system = "aarch64-darwin";
    defaultGithubUser = "gn-dave-a";
    homeModules = [
      ../../home/darwin
      (
        { lib, pkgs, ... }:
        {
          programs.ssh.matchBlocks = config-nix-private.sshConfig.work;
          programs.keychain.keys = lib.mkAfter [
            "0x3F92E3893C4349DD"
            "0x4C030895BE1EEBE1"
          ];
          home.sessionVariables = config-nix-private.additionalSessionVariables.work;
          home.packages = lib.mkAfter (
            with pkgs;
            [
              binaryen
              corepack
            ]
          );
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
        homebrew.brews = lib.mkAfter [ "dvc" ];
        homebrew.casks = lib.mkAfter [ ];
        homebrew.taps = lib.mkAfter [ ];
      }
    )
  ];
}
