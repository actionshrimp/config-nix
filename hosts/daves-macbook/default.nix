config-nix-private: {
  system = "aarch64-darwin";
  hostName = "daves-macbook";
  homeConfig = {
    homeDirectory = "/Users/dave";
    stateVersion = "22.05";
    sshKeys = [ "id_ed25519" ] ++ config-nix-private.sshKeys.work;
    sshConfig = config-nix-private.sshConfig.work;
    homeModules = [ ../../home/darwin ];
    apiKeys = {
      openAi = config-nix-private.apiKeys.work.openAi;
    };
  };
  systemConfig = {
    buildMachines = config-nix-private.buildMachines;
    sshKnownHosts = config-nix-private.sshKnownHosts;

    # Manually add AWS creds to:
    # - ~/.aws/credentials (for user auth)
    # - /var/root/.aws/credentials (for nix-daemon auth)
    extraSubstituters = [
      "s3://imandra-nix-cache?profile=imandra-nix-cache&endpoint=https://storage.googleapis.com"
    ];
    extraTrustedSubstituters = [
      "s3://imandra-nix-cache?profile=imandra-nix-cache&endpoint=https://storage.googleapis.com"
    ];
    extraTrustedPublicKeys = [
      "imandra-nix-cache.1:4rM4urW8DwdkG+ipwCR/DHHB67xOm2A7FIoCLD1DEMQ="
    ];

    # Manually add (key used by nix _client_ to sign builds - daemon doesn't need access)
    # - imandra-nix-cache-signing-key
    # - to /Users/dave/.keys/cache-priv-key.pem
    # - chmod 600 
    nixSecretKeyFiles = [ "/Users/dave/.keys/cache-priv-key.pem" ];
  };
  homebrewCasks = [ ];
}
