{ pkgs, ... }: {

  home.packages = [
    pkgs.tree
    pkgs.coreutils
    pkgs.pinentry_mac
    pkgs.iterm2
  ];


  home.sessionPath = [ "/opt/homebrew/bin" ];

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
