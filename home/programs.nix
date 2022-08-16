{ homeDirectory }:

{
  zsh = import ./zsh.nix { inherit homeDirectory; };
}
