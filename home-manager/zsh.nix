{ pkgs }:

{
  enable = true;

  autocd = false;
  enableAutosuggestions = true;
  enableCompletion = true;
  initExtra = (builtins.readFile ./scripts/init.sh);
}
