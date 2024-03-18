{ configModule, outputName }: { config, pkgs, lib, ... }: {

  programs.zsh = {
    shellAliases = {
      ns = "vim ${(toString configModule)}";
      nss = ''
        pushd ${config.home.homeDirectory}/config-nix && ((nix build .#darwinConfigurations.${outputName}.system && su admin -c "./result/sw/bin/darwin-rebuild switch --flake .#${outputName}") || true) && popd
      '';
    };
  };

  home.packages = [
    pkgs.tree
    pkgs.emacsMacport
    pkgs.coreutils
    pkgs.pinentry_mac
  ];


  home.sessionPath = [ "/opt/homebrew/bin" ];

  home.file.".config/karabiner" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/config-nix/dotfiles/config/karabiner";
  };

  programs.zsh = {
    initExtra = ''
      vnodes() {
        echo $(sudo sysctl kern.num_vnodes) / $(sudo sysctl kern.maxvnodes)
      }

      mksudo() {
        MINS="''${1:-5}"
        SECS=$(( $MINS * 60 ))
        echo Temporarily granting sudo access to $USER for "$MINS"m...
        DOREVOKE="echo Revoking... && dseditgroup -o edit -d $USER -t user admin && echo Revoked."
        DOGRANT="dseditgroup -o edit -a $USER -t user admin && echo Granted."
        su admin -c "sudo bash -c \"trap \\\"$DOREVOKE\\\" EXIT && "$DOGRANT" && sleep $SECS\""
      }
    '';
  };
}
