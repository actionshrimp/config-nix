config-nix-private: {
  hostName = "daves-macbook";
  homeConfig = {
    homeDirectory = "/Users/dave";
    stateVersion = "22.05";
    sshKeys = [ "id_ed25519" ] ++ config-nix-private.sshKeys.work;
    sshConfig = config-nix-private.sshConfig.work;
    homeModules = [ ../../home/darwin ];
  };
  systemConfig = {
    buildMachines = config-nix-private.buildMachines;
    sshKnownHosts = config-nix-private.sshKnownHosts;
  };
  homebrewCasks = [ ];
}
