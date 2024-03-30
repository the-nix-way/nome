{ pkgs }:

{
  enable = true;

  defaultEditor = false;
  languages = { language = [{ name = "rust"; auto-format = true; }]; };
  package = pkgs.helix;
  settings = { };
}
