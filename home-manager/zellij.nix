{ pkgs }:

{
  enable = true;

  package = pkgs.zellij;
  enableZshIntegration = true;
  settings = {
    show_startup_tips = false;
    theme = "catppuccin-mocha";
  };
}
