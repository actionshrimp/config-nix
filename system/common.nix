{ buildMachines, sshKnownHosts }: { pkgs, nix, nixpkgs, config, lib, ... }: {

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    cachix
  ];

  programs.zsh.enable = true;

  programs.ssh.knownHosts = sshKnownHosts;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    distributedBuilds = true;
    inherit buildMachines;
    package = pkgs.nixVersions.nix_2_20;
    settings.substituters = [ "https://cache.nixos.org/" "https://nix-community.cachix.org" ];
    settings.trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
