# config-nix

- nix-darwin / nixos configuration
- home-manager configuration
- static dotfiles

## Setup

```
$ nix-shell -p vim
$ sudo vim /etc/nixos/configuration.nix
<set defaultUser, add dave user>
$ sudo nixos-rebuild switch

<as dave>:
$ ssh-keygen -t ed25519 -C "your_email@example.com"
<add to github>

$ git clone git@github.com:actionshrimp/config-nix.git ~/config-nix
$ git clone git@github.com:actionshrimp/config-nix-private.git ~/config-nix-private
```

### NixOS

Get flakes enabled in the default /etc/nixos/configuration.nix (already done on NixOS-WSL).

Install the first generation

    sudo nixos-rebuild switch --flake .#hyperv-nixos

### MacOS

Install the first generation (also needs flakes enabled):

    nix build .#darwinConfigurations.daves-macbook.system
    ./result/sw/bin/darwin-rebuild switch --flake .#daves-macbook

#### homebrew

You need to manually install homebrew using the homebrew installer for nix-darwin to be able to manage homebrew packages.

## Troubleshooting

Error on macos when applying via a separate 'admin' account:

```
error:
       … while fetching the input 'git+file:///Users/dave/config-nix'

       error: opening Git repository '"/Users/dave/config-nix"': repository path '/Users/dave/config-nix/' is not owned by current user
```

Need to mark this repo as safe for the admin user. Add this to `/Users/admin/.config/git/config`:

```
[safe]
   directory = /Users/dave/config-nix
```
