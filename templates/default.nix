rec {
  ec = editorconfig;

  editorconfig = {
    path = ./editorconfig;
    description = "editorconfig file template";
  };

  nix = {
    path = ./nix;
    description = "Nix template";
  };

  proj = {
    path = ./proj;
    description = "Nome project starter template";
  };
}
