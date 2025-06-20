{ pkgs }:

{
  enable = true;

  extensions = [ "nix" ];
  package = pkgs.zed-editor;
}
