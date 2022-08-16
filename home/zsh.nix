{ homeDirectory }:

{
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  autocd = false;
  initExtra = builtins.readFile ./scripts/init.sh (substituteAll {
    src = ./scripts/init.sh;
    home = homeDirectory;
  });
  shellAliases = import ./aliases.nix { inherit homeDirectory; };
}
