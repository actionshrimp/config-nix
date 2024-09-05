FROM nixos/nix

# disable filtering of syscalls and enable nix-command and flakes
RUN echo "filter-syscalls = false" >> /etc/nix/nix.conf 
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
RUN echo "sandbox = false" >> /etc/nix/nix.conf
RUN echo "system-features = kvm" >> /etc/nix/nix.conf
