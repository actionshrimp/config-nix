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

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    settings.trusted-users = [ "dave" ];
    distributedBuilds = true;

    settings.substituters = [
      "https://devenv.cachix.org"
      "https://nix-community.cachix.org"
      "https://anmonteiro.nix-cache.workers.dev"
    ];
    settings.trusted-substituters = [
      "https://devenv.cachix.org"
      "https://nix-community.cachix.org"
      "https://anmonteiro.nix-cache.workers.dev"
    ];
    settings.trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ocaml.nix-cache.com-1:/xI2h2+56rwFfKyyFVbkJSeGqSIYMC/Je+7XXqGKDIY="
    ];
  };
}
