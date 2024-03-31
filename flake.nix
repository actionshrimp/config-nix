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

    config-nix-private.url = "git+file:///Users/dave/config-nix-private";
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
    , config-nix-private ? {
        sshConfig = {
          personal = { };
          work = { };
        };
        sshKeys = {
          personal = { };
          work = { };
        };
        sshKnownHosts = { };
        buildMachines = [ ];
      }
    , ...
    }:
    let
      mkHomeOverlays = system: [
        nur.overlay
        (self: super: {
          nurl = nurl.packages.${system}.default;
          nix-direnv = nix-direnv.packages.${system}.default;
        })
      ];

      homeManagerConfig = { homeDirectory, stateVersion, sshKeys, sshConfig, homeModules }: homeOverlays:
        let
          common = (import ./home {
            inherit homeOverlays;
            inherit homeDirectory;
            inherit stateVersion;
            inherit sshKeys;
            inherit sshConfig;
          });
        in
        { lib, pkgs, ... }: {
          home.username = "dave";
          home.homeDirectory = homeDirectory;
          home.stateVersion = stateVersion;
          imports = [ common ] ++ homeModules;
        };

      systemCommon = { buildMachines, sshKnownHosts }:
        (import ./system/common.nix {
          inherit buildMachines;
          inherit sshKnownHosts;
        });

      darwinSystem = { hostName, homeConfig, systemConfig, homebrewCasks }:
        let
          system = "aarch64-darwin";
        in
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
            (systemCommon systemConfig)
            (import ./system/darwin/darwin-configuration.nix
              { inherit hostName; inherit homebrewCasks; })
            home-manager.darwinModules.home-manager
            { home-manager.users.dave = homeManagerConfig homeConfig (mkHomeOverlays system); }
          ];
          specialArgs = { inherit nixpkgs; };
        };

      nixosSystem = { hostName, homeConfig, systemConfig, configModule, ... }@hostConfig:
        let system = "x86_64-linux"; in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (systemCommon systemConfig)
          ] ++ (if hostConfig ? hardwareConfiguration then [
            hostConfig.hardwareConfiguration
          ] else [
          ]) ++ [
            (import configModule {
              inherit hostName;
              inherit nixos-wsl;
            })
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.dave = homeManagerConfig homeConfig (mkHomeOverlays system);
            }
          ];
        };
      mkHost = f: (import f config-nix-private);
    in
    {
      nixosConfigurations = {
        baracus-hyperv = nixosSystem (mkHost ./hosts/baracus-hyperv);
        baracus-wsl = nixosSystem (mkHost ./hosts/baracus-wsl);
      };
      darwinConfigurations = {
        daves-macbook = darwinSystem (mkHost ./hosts/daves-macbook);
        marco = darwinSystem (mkHost ./hosts/marco);
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
