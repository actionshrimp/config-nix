# based on https://github.com/sebastiant/dotfiles/blob/master/flake.nix, thanks!
{
  description = "NixOS and home-manager configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-25.05-darwin";
    nur.url = "github:nix-community/nur";
    nurl.url = "github:nix-community/nurl";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-direnv.url = "github:nix-community/nix-direnv";

    flake-utils.url = "github:numtide/flake-utils";

    config-nix-private.url = "git+file:///Users/dave/config-nix-private";
    # or "git+ssh://git@github.com/actionshrimp/config-nix-private";
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
        additionalSessionVariables = {
          personal = { };
          work = { };
        };
        sshConfig = {
          personal = { };
          work = { };
        };
      },
      ...
    }:
    let
      mkHomeOverlays =
        { system, ... }@homeConfig:
        [
          nur.overlay
          (self: super: {
            nurl = nurl.packages.${system}.default;
            nix-direnv = nix-direnv.packages.${system}.default;
          })
        ];

      homeManagerModule =
        { homeConfig, ... }@hostConfig:
        let
          homeOverlays = mkHomeOverlays homeConfig;

          common = (
            import ./home {
              inherit homeConfig;
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
        hostConfig:
        let
          system = "aarch64-darwin";
        in
        darwin.lib.darwinSystem {
          inherit system;
          modules = hostConfig.darwinModules ++ [
            home-manager.darwinModules.home-manager
            { home-manager.users.dave = homeManagerModule hostConfig; }
          ];
          specialArgs = {
            inherit nixpkgs;
          };
        };

      nixosSystem =
        {
          hostName,
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
            [ (import ./system/common.nix) ]
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
    in
    {
      homeConfigurations = nixpkgs.lib.attrsets.mapAttrs (
        k: v: (homeManagerConfig hostConfigs."${k}" v)
      ) hostConfigs;
      nixosConfigurations = {
        baracus-hyperv = nixosSystem (hostConfigs.baracus-hyperv);
        baracus-wsl = nixosSystem (hostConfigs.baracus-wsl);
      };
      darwinConfigurations = {
        daves-macbook = darwinSystem (hostConfigs.daves-macbook);
        marco = darwinSystem (hostConfigs.marco);
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
