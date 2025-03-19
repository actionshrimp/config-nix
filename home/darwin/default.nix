{ pkgs, ... }:
{

  home.packages = [
    pkgs.tree
    pkgs.coreutils
    pkgs.pinentry_mac
    pkgs.iterm2
    pkgs.stats

    # Alias sed to gsed to appease macos programs that expect gsed as gsed (nvim-spectre) -_-
    (pkgs.buildEnv {
      name = "symlink-gsed";
      paths = [
        pkgs.gnused
        (pkgs.runCommand "symlink-gsed" { } ''
          mkdir -p $out/bin
          ln -s ${pkgs.gnused}/bin/sed $out/bin/gsed
        '')
      ];
    })
  ];

  home.sessionPath = [ "/opt/homebrew/bin" ];

  programs.zsh = {
    initExtra = ''
      ulimit -n 99999

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
