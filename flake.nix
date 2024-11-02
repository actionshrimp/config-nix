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
    {
      darwin,
      home-manager,
      nur,
      nurl,
      nixpkgs,
      nixos-wsl,
      nix-direnv,
      flake-utils,
      config-nix-private ? {
        apiKeys = {
          openAi = "";
        };
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
      },
      ...
    }:
    let
      mkHomeOverlays = system: [
        nur.overlay
        (self: super: {
          nurl = nurl.packages.${system}.default;
          nix-direnv = nix-direnv.packages.${system}.default;
        })
      ];

      homeManagerModule =
        { homeConfig, system, ... }@hostConfig:
        let
          homeOverlays = mkHomeOverlays system;

          common = (
            import ./home {
              inherit (homeConfig)
                homeDirectory
                stateVersion
                sshKeys
                sshConfig
                apiKeys
                ;
              inherit homeOverlays;
            }
          );
        in
        { ... }@moduleArgs:
        {
          home.username = "dave";
          home.homeDirectory = homeConfig.homeDirectory;
          home.stateVersion = homeConfig.stateVersion;
          imports = [ common ] ++ homeConfig.homeModules;
        };

      homeManagerConfig =
        { system, ... }@hostConfig:
        mod:
        let
          mod = homeManagerModule hostConfig;

        in
        home-manager.lib.homeManagerConfiguration {
          modules = [ mod ];
          pkgs = nixpkgs.legacyPackages.${system};
        };

      darwinSystem =
        {
          hostName,
          systemConfig,
          homebrewCasks,
          ...
        }@hostConfig:
        homeManagerConfiguration:
        let
          system = "aarch64-darwin";
        in
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
            (import ./system/common.nix systemConfig)
            (import ./system/darwin/darwin-configuration.nix {
              inherit hostName;
              inherit homebrewCasks;
            })
            home-manager.darwinModules.home-manager
            { home-manager.users.dave = homeManagerConfiguration; }
          ];
          specialArgs = {
            inherit nixpkgs;
          };
        };

      nixosSystem =
        {
          hostName,
          systemConfig,
          configModule,
          ...
        }@hostConfig:
        homeManagerConfiguration:
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            [ (import ./system/common.nix systemConfig) ]
            ++ (if hostConfig ? hardwareConfiguration then [ hostConfig.hardwareConfiguration ] else [ ])
            ++ [
              (import configModule {
                inherit hostName;
                inherit nixos-wsl;
              })
              home-manager.nixosModules.home-manager
              {
                home-manager.useUserPackages = true;
                home-manager.users.dave = homeManagerConfiguration;
              }
            ];
        };
      mkHost = f: (import f config-nix-private);
      hostConfigs = {
        daves-macbook = (mkHost ./hosts/daves-macbook);
        marco = (mkHost ./hosts/marco);
        baracus-hyperv = (mkHost ./hosts/baracus-hyperv);
        baracus-wsl = (mkHost ./hosts/baracus-wsl);
      };
      homeManagerModules = {
        daves-macbook = homeManagerModule hostConfigs.daves-macbook;
        marco = homeManagerModule hostConfigs.marco;
        baracus-hyperv = homeManagerModule hostConfigs.baracus-hyperv;
        baracus-wsl = homeManagerModule hostConfigs.baracus-wsl;
      };
    in
    {
      homeConfigurations = nixpkgs.lib.attrsets.mapAttrs (
        k: v: (homeManagerConfig hostConfigs."${k}" v)
      ) homeManagerModules;
      nixosConfigurations = {
        baracus-hyperv = nixosSystem (mkHost ./hosts/baracus-hyperv) homeManagerModules.baracus-hyperv;
        baracus-wsl = nixosSystem (mkHost ./hosts/baracus-wsl) homeManagerModules.baracus-wsl;
      };
      darwinConfigurations = {
        daves-macbook = darwinSystem (mkHost ./hosts/daves-macbook) homeManagerModules.daves-macbook;
        marco = darwinSystem (mkHost ./hosts/marco) homeManagerModules.marco;
      };
    }
    // (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
        devShell = pkgs.mkShell { buildInputs = with pkgs; [ nixfmt-rfc-style ]; };
      }
    ));
}
