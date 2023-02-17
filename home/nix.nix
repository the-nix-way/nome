{ nix }:

{
  package = nix;
  settings = {
    sandbox = true;
    substituters = [ "https://cache.nixos.org" ];
    binary-caches = [ "https://cache.nixos.org" ];
    trusted-substituters = [ "https://cache.nixos.org" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  };
}
