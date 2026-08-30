config-nix-private:
let
  username = "dave.aitken";
  homeDirectory = "/Users/dave.aitken";
  darwinOpts = {
    hostName = "daves-macbook";
    inherit username homeDirectory;
    ## Remove for new systems
    nixbldGid = 30000;
  };
in
{
  homeConfig = {
    inherit username homeDirectory;
    stateVersion = "22.05";
    system = "aarch64-darwin";
    homeModules = [
      ../../home/darwin
      # Work claude skills; kept out of the public repo.
      (config-nix-private.claudeSkills or { })
      (
        { lib, pkgs, ... }:
        {
          programs.ssh.matchBlocks = config-nix-private.sshConfig.work;
          programs.keychain.keys = lib.mkAfter [
            "id_ed25519"
          ];
          home.sessionVariables = config-nix-private.additionalSessionVariables.work;
          home.packages = lib.mkAfter (
            with pkgs;
            [
              binaryen
              # corepack: nodejs_22 now ships bin/corepack, which collides here
            ]
          );

        }
      )
    ];
  };
  darwinModules = [
    (import ../../system/common.nix)
    (import ../../system/darwin/darwin-configuration.nix darwinOpts)
    (
      { lib, ... }:
      {
        homebrew.brews = lib.mkAfter [
          "schpet/tap/linear"
          "schpet/tap/envset"
          "llama.cpp"
          # The dopplerhq/cli tap turned doppler into a cask; homebrew-core
          # still ships it as a formula, which is what's installed anyway.
          "doppler"
          "common-fate/granted/granted"
          "nvm"
          "libmagic"
          "gettext"
        ];
        homebrew.casks = lib.mkAfter [ ];
        homebrew.taps = lib.mkAfter [ ];
      }
    )
  ];
}
