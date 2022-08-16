{ homeDirectory }:

{
  enable = true;
  shellAliases = import ./aliases.nix { inherit homeDirectory; };
}
