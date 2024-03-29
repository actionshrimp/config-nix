{ hostName }: { pkgs, nix, nixpkgs, config, lib, ... }: {

  users = { users.dave = { home = "/Users/dave"; }; };

  networking.hostName = hostName;

  services.nix-daemon.enable = true;

  services.postgresql = {
    package = pkgs.postgresql_14;
    enable = true;

    # had to create this manually for now due to:
    # https://github.com/LnL7/nix-darwin/issues/339
    #
    # Use:
    # mkdir -p ~/.share/postgres
    # launchctl start org.nixos.postgres

    # nix-darwin runs `initdb -U postgres`, although by default there is no
    # postgres user created. To add a user for your username, use:
    # createuser -U postgres --createdb --superuser dave

    dataDir = "/Users/dave/.share/postgres";

    authentication = ''
      local all all              peer
      host  all all localhost    trust
      host  all all 127.0.0.1/32 md5
      host  all all ::1/128      md5
    '';
  };

  launchd.user.agents.postgresql.serviceConfig = {
    # Un-comment these values instead to avoid a home-manager dependency.
    StandardErrorPath = "/Users/dave/.share/postgres/postgres.error.log";
    StandardOutPath = "/Users/dave/.share/postgres/postgres.out.log";
  };

  system.defaults = {
    NSGlobalDomain.InitialKeyRepeat = 20;
    NSGlobalDomain.KeyRepeat = 1;
    dock.autohide = true;
    dock.autohide-time-modifier = 0.4;
    dock.autohide-delay = 1000.0;
  };

  homebrew = {
    enable = true;
    taps = [ "homebrew/cask-fonts" ];
    brews = [ ];
    casks = [ "font-source-code-pro" "font-jetbrains-mono-nerd-font" ];
  };
}
