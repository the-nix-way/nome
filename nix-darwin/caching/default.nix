{ cachix
, username
}:

{
  config = {
    nix = {
      settings = {
        substituters = [
          "https://cache.nixos.org"
          "https://${cachix.cache}.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          cachix.publicKey
        ];
        trusted-substituters = [ "https://cache.nixos.org" "https://the-nix-way.cachix.org" ];
        trusted-users = [ "root" username ];
      };
    };
  };
}
