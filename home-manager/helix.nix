{ pkgs }:

{
  enable = true;

  defaultEditor = false;
  package = pkgs.helix;
  settings = {
    editor = {
      auto-format = true;
    };
    theme = "catppuccin_mocha";
  };
}
