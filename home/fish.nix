{ homeDirectory
, pkgs
}:

{
  enable = true;
  plugins = [
    {
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
        sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
      };
    }
    {
      name = "fasd";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "plugin-fasd";
        rev = "98c4c729780d8bd0a86031db7d51a97d55025cf5";
        sha256 = "sha256-8JASaNylXAGnWd2IV88juk73b8eJJlVrpyiRZUwHGFQ=";
      };
    }
  ];
  shellAliases = (import ./aliases.nix { inherit homeDirectory; }).shell;
}
