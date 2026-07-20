config-nix-private:
let
  username = "dave.aitken";
  homeDirectory = "/Users/dave.aitken";
  darwinOpts = {
    hostName = "daves-macbook";
    inherit username homeDirectory;
    ## Remove for new systems
    nixbldGid = 30000;
  };
in
{
  homeConfig = {
    inherit username homeDirectory;
    stateVersion = "22.05";
    system = "aarch64-darwin";
    homeModules = [
      ../../home/darwin
      (
        { lib, pkgs, ... }:
        {
          programs.ssh.matchBlocks = config-nix-private.sshConfig.work;
          programs.keychain.keys = lib.mkAfter [
            "id_ed25519"
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
    (import ../../system/darwin/gn-nginx.nix)
    (
      { lib, ... }:
      {
        homebrew.brews = lib.mkAfter [
          "dvc"
          "schpet/tap/linear"
          "llama.cpp"
        ];
        homebrew.casks = lib.mkAfter [ ];
        homebrew.taps = lib.mkAfter [ ];
      }
    )
  ];
}
