{ pkgs }:

{
  enable = true;

  enableZshIntegration = true;
  package = pkgs.ghostty;
  settings = {
    theme = "catppuccin-mocha";
    font-size = 10;
  };
}
