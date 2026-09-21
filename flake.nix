# based on https://github.com/sebastiant/dotfiles/blob/master/flake.nix, thanks!
{
  description = "NixOS and home-manager configurations";

  inputs = {

    # update from latest version on https://status.nixos.org/
    # nixpkgs-26.05-darwin
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    # unstable, used to pull individual packages not yet on the release branch
    # (e.g. worktrunk) via the home overlay below.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-direnv = {
      url = "github:nix-community/nix-direnv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    # Fetched over ssh rather than from a sibling checkout: a relative
    # git+file: path is resolved against the process working directory, so nix
    # treats it as an unlocked input and refuses to write flake.lock at all,
    # silently pinning this input to whatever rev the lock already held.
    # Commits here must be pushed before they reach a rebuild; edits to files
    # already linked out of the checkout still apply without one.
    config-nix-private.url = "git+ssh://git@github.com/actionshrimp/config-nix-private";
  };

  outputs =
    {
      darwin,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
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
          (self: super: {
            nix-direnv = nix-direnv.packages.${system}.default;
            # 26.05 has worktrunk 0.50.0; unstable tracks it much more closely
            # (0.74.0), so keep pulling it from there.
            worktrunk = nixpkgs-unstable.legacyPackages.${system}.worktrunk;
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
          home.username = homeConfig.username;
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
          username = hostConfig.homeConfig.username;
        in
        darwin.lib.darwinSystem {
          inherit system;
          modules = hostConfig.darwinModules ++ [
            home-manager.darwinModules.home-manager
            { home-manager.users.${username} = homeManagerModule hostConfig; }
          ];
          specialArgs = {
            inherit nixpkgs username;
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
          username = hostConfig.homeConfig.username;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit username;
          };
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
                home-manager.users.${username} = homeManagerConfiguration;
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
