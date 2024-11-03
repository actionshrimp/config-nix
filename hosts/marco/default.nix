config-nix-private: {
  system = "aarch64-darwin";
  hostName = "marco";
  homeConfig = {
    homeDirectory = "/Users/dave";
    stateVersion = "22.05";
    sshKeys = [ "id_ed25519" ] ++ config-nix-private.sshKeys.personal;
    sshConfig = config-nix-private.sshConfig.personal;
    homeModules = [
      ../../home/darwin
      ../../home/syncthing.nix
    ];
    apiKeys = {
      anthropic = config-nix-private.apiKeys.personal.anthropic;
    };
  };
  systemConfig = {
    buildMachines = config-nix-private.buildMachines;
    sshKnownHosts = config-nix-private.sshKnownHosts;
    extraSubstituters = [ ];
    extraTrustedSubstituters = [ ];
    extraTrustedPublicKeys = [ ];
    nixSecretKeyFiles = [ ];
  };
  homebrewCasks = [ ];
}
