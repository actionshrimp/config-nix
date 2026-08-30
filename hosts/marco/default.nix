config-nix-private:
let
  username = "dave";
  homeDirectory = "/Users/dave";
  darwinOpts = {
    hostName = "marco";
    inherit username homeDirectory;
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
        { config, lib, ... }:
        {
          # localhost:8384
          services.syncthing.enable = true;
          programs.ssh.matchBlocks = config-nix-private.sshConfig.personal;
          programs.keychain.keys = lib.mkAfter [
            "id_ed25519"
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
          "llama.cpp"
        ];
        homebrew.casks = lib.mkAfter [
          "zulu@17"
        ];
        homebrew.taps = lib.mkAfter [ ];
      }
    )
  ];
}
