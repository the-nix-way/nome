{ caches
, username
}:

{
  config = {
    nix = {
      settings = rec {
        substituters = with caches; [
          nixos-org.cache
          nix-community.cache
        ];
        trusted-public-keys = with caches; [
          nixos-org.publicKey
          nix-community.publicKey
        ];
        trusted-substituters = substituters;
        trusted-users = [ "root" username ];
      };
    };
  };
}
