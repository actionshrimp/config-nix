{ hostName }: { lib, pkgs, nixpkgs, config, nixos-wsl, modulesPath, ... }:

with lib;
let defaultUser = "dave"; in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    nixos-wsl.nixosModules.wsl
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  wsl = {
    enable = true;
    wslConf = { automount = { root = "/mnt"; }; };
    defaultUser = defaultUser;
    startMenuLaunchers = false;
    nativeSystemd = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  networking.hostName = hostName;

  users.users.${defaultUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "22.05";

  environment.pathsToLink = [ "/share/zsh" ];

  systemd.services.nixs-wsl-systemd-fix = {
    description = "Fix the /dev/shm symlink to be a mount";
    unitConfig = {
      DefaultDependencies = "no";
      Before = [
        "sysinit.target"
        "systemd-tmpfiles-setup-dev.service"
        "systemd-tmpfiles-setup.service"
        "systemd-sysctl.service"
      ];
      ConditionPathExists = "/dev/shm";
      ConditionPathIsSymbolicLink = "/dev/shm";
      ConditionPathIsMountPoint = "/run/shm";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.coreutils-full}/bin/rm /dev/shm"
        "/run/wrappers/bin/mount --bind -o X-mount.mkdir /run/shm /dev/shm"
      ];
    };
    wantedBy = [ "sysinit.target" ];
  };
}
