{ caches
, username
}:

{
  config = {
    nix = {
      settings = rec {
        substituters = with caches; [
          nixos-org.cache
          the-nix-way.cache
          nix-community.cache
        ];
        trusted-public-keys = with caches; [
          nixos-org.publicKey
          the-nix-way.publicKey
          nix-community.publicKey
        ];
        trusted-substituters = substituters;
        trusted-users = [ "root" username ];
      };
    };
  };
}
