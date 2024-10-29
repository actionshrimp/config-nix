config-nix-private: {
  system = "x86_64-linux";
  hostName = "baracus-wsl-nixos";
  homeConfig = {
    homeDirectory = "/home/dave";
    stateVersion = "22.05";
    sshKeys = [ "id_ed25519" ] ++ config-nix-private.sshKeys.personal;
    sshConfig = config-nix-private.sshConfig.personal;
    homeModules = [ ../../home/linux ];
  };
  systemConfig = {
    buildMachines = config-nix-private.buildMachines;
    sshKnownHosts = config-nix-private.sshKnownHosts;
    extraSubstituters = [ ];
    extraTrustedSubstituters = [ ];
    extraTrustedPublicKeys = [ ];
    nixSecretKeyFiles = [ ];
  };
  configModule = ../../system/nixos-wsl/configuration.nix;
}
