{ buildMachines, sshKnownHosts }: { pkgs, nix, nixpkgs, config, lib, ... }: {
  imports = [
    # run cachix use nix-community to generate this
    ../nixos/cachix.nix
  ];

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
    package = pkgs.nixVersions.nix_2_18;
  };
}
