{ pkgs }:

{
  enable = true;

  autocd = false;
  autosuggestion.enable = true;
  enableCompletion = true;
  initContent = builtins.readFile ./scripts/init.sh;
  package = pkgs.zsh;
}
