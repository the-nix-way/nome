{ pkgs }:

{
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  autocd = false;
  initExtra = (builtins.readFile ./scripts/init.sh);
  shellAliases = (import ./aliases.nix { inherit pkgs; }).shell;
}
