{
  buildMachines,
  sshKnownHosts,
  nixSecretKeyFiles,
  extraSubstituters,
  extraTrustedSubstituters,
  extraTrustedPublicKeys,
}:
{
  pkgs,
  nix,
  nixpkgs,
  config,
  lib,
  ...
}:
{

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
    settings.trusted-users = [ "dave" ];
    distributedBuilds = true;
    inherit buildMachines;
    package = pkgs.nixVersions.nix_2_23;
    settings.secret-key-files = nixSecretKeyFiles;
    settings.substituters = [
      "https://nix-community.cachix.org"
      "https://anmonteiro.nix-cache.workers.dev"
    ] ++ extraSubstituters;
    settings.trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://anmonteiro.nix-cache.workers.dev"
    ] ++ extraTrustedSubstituters;
    settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ocaml.nix-cache.com-1:/xI2h2+56rwFfKyyFVbkJSeGqSIYMC/Je+7XXqGKDIY="
    ] ++ extraTrustedPublicKeys;
  };
}
