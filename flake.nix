# based on https://github.com/sebastiant/dotfiles/blob/master/flake.nix, thanks!
{
  description = "NixOS and home-manager configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    nurl.url = "github:nix-community/nurl";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-direnv.url = "github:nix-community/nix-direnv";

    flake-utils.url = "github:numtide/flake-utils";

    config-nix-private.url = "git+ssh://git@github.com/actionshrimp/config-nix-private";
  };

  outputs =
    { darwin
    , home-manager
    , nur
    , nurl
    , nixpkgs
    , nixos-wsl
    , nix-direnv
    , flake-utils
    , config-nix-private ? { sshConfig = { }; sshKeys = { }; sshKnownHosts = { }; buildMachines = [ ]; }
    , ...
    }:
    let
      privateSshConfig = config-nix-private.sshConfig;
      privateSshKeys = config-nix-private.sshKeys;

      sshKnownHosts = config-nix-private.sshKnownHosts;
      buildMachines = config-nix-private.buildMachines;

      homeManagerConfFor = { system, homeDirectory, stateVersion, sshKeys }: targetConfig: extraModules:
        let
          commonHome = (import ./home/common {
            sshKeys = sshKeys ++ privateSshKeys;
            sshConfig = privateSshConfig;
          });
        in
        { config, lib, pkgs, ... }: {
          nixpkgs.overlays = [
            nur.overlay
            (self: super: {
              nurl = nurl.packages.${system}.default;
              nix-direnv = nix-direnv.packages.${system}.default;
            })
          ];
          nixpkgs.config.allowUnfree = true;
          home.username = "dave";
          home.homeDirectory = homeDirectory;
          home.stateVersion = stateVersion;
          imports = [ commonHome targetConfig ] ++ extraModules;
        };
      darwinSystem = hostName: extraHomeModules:
        let
          system = "aarch64-darwin";
          darwinConfigModule = ./hosts/macbook/darwin-configuration.nix;
        in
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
            (import ./hosts/common.nix { inherit buildMachines; inherit sshKnownHosts; })
            (import darwinConfigModule { inherit hostName; })
            home-manager.darwinModules.home-manager
            {
              home-manager.users.dave =
                homeManagerConfFor
                  {
                    inherit system;
                    homeDirectory = "/Users/dave";
                    stateVersion = "22.05";
                    sshKeys = [ "id_ed25519" ];
                  }
                  (import ./home/macos {
                    configModule = darwinConfigModule;
                    outputName = hostName;
                  })
                  extraHomeModules;
            }
          ];
          specialArgs = { inherit nixpkgs; };
        };
    in
    {
      nixosConfigurations =
        let
          system = "x86_64-linux";
          nixosConfigModule = ./hosts/hyperv-nixos/configuration.nix;
          extraHomeModules = [ ];
        in
        {
          hyperv-nixos = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              (import ./hosts/common.nix { inherit buildMachines; inherit sshKnownHosts; })
              (import nixosConfigModule { hostName = "hyperv-nixos"; })
              home-manager.nixosModules.home-manager
              {
                home-manager.useUserPackages = true;
                home-manager.users.dave =
                  homeManagerConfFor
                    {
                      inherit system;
                      homeDirectory = "/home/dave";
                      stateVersion = "22.05";
                      sshKeys = [ "id_ed25519" ];
                    }
                    (import ./home/linux {
                      configModule = nixosConfigModule;
                      outputName = "hyperv-nixos";
                    })
                    extraHomeModules;
              }
            ];

            specialArgs = { inherit nixpkgs; };
          };
          wsl-nixos =
            let
              system = "x86_64-linux";
              nixosConfigModule = ./hosts/wsl-nixos/configuration.nix;
              extraHomeModules = [ ];
            in
            nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                (import ./hosts/common.nix { inherit buildMachines; inherit sshKnownHosts; })
                (import nixosConfigModule { hostName = "wsl-nixos"; })
                home-manager.nixosModules.home-manager
                {
                  home-manager.useUserPackages = true;
                  home-manager.users.dave =
                    homeManagerConfFor
                      {
                        inherit system;
                        homeDirectory = "/home/dave";
                        stateVersion = "22.05";
                        sshKeys = [ "id_ed25519" ];
                      }
                      (import ./home/linux {
                        configModule = nixosConfigModule;
                        outputName = "wsl-nixos";
                      })
                      extraHomeModules;
                }

              ];

              specialArgs = {
                inherit nixpkgs;
                inherit nixos-wsl;
              };
            };
        };

      darwinConfigurations = {
        daves-macbook = darwinSystem "daves-macbook" [ ];
      };

    } // (flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system};
    in {
      formatter = pkgs.nixpkgs-fmt;
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
        ];
      };
    }));
}
