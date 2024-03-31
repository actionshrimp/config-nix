{ config, pkgs, lib, ... }: {
  home.packages = [
    pkgs.syncthing
  ];
}
