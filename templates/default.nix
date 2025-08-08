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
}
