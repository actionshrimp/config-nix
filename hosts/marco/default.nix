config-nix-private: {
  hostName = "marco";
  homeConfig = {
    homeDirectory = "/Users/dave";
    stateVersion = "22.05";
    sshKeys = [ "id_ed25519" ] ++ config-nix-private.sshKeys.personal;
    sshConfig = config-nix-private.sshConfig.personal;
    homeModules = [ ../../home/darwin ../../home/syncthing.nix ];
  };
  systemConfig = {
    buildMachines = config-nix-private.buildMachines;
    sshKnownHosts = config-nix-private.sshKnownHosts;
  };
  homebrewCasks = [ "rekordbox" ];
}
