{ pkgs }:

{
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  autocd = false;
  initExtra = (builtins.readFile ./scripts/init.sh);
}
