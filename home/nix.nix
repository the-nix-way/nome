{ nix }:

{
  package = nix;
  settings = {
    sandbox = true;
    substituters = [ "https://cache.nixos.org" ];
    experimental-features = [ "flakes" "nix-command" ];
  };
}
