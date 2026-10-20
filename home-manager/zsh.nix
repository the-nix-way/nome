{ pkgs }:

{
  enable = true;

  autocd = false;
  autosuggestion.enable = true;
  defaultKeymap = "emacs";
  enableCompletion = true;
  initContent = builtins.readFile ./scripts/init.sh;
  package = pkgs.zsh;
}
