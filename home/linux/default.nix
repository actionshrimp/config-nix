{ configModule, outputName }: { config, pkgs, lib, ... }: {

  services.gpg-agent = {
    enable = true;
    verbose = true;

    defaultCacheTtl = 1209600;
    maxCacheTtl = 1209600;
    pinentryFlavor = "curses";

    extraConfig = ''
      debug-level 9
      allow-preset-passphrase
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  services.dropbox.enable = true;
  services.keybase.enable = true;
  services.kbfs.enable = true;
  services.lorri.enable = true;

  programs.zsh = {
    shellAliases = {
      ns = "vim ${configModule}";
      nss =
        "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/config-nix#${outputName}";
    };
  };

  home.packages = [
    pkgs.dig
    pkgs.emacs
    pkgs.pinentry
  ];
}
