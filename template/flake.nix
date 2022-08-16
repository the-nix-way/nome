{
  description = "TODO";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
    nome.url = "github:the-nix-way/nome";
  };

  outputs = { self, flake-utils, nixpkgs, nome }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) mkShell;
      in
      {
        devShells = {
          default = mkShell {
            buildInputs = with nome.lib.dev.tools;
              go ++ node ++ protobuf;
          };
        };
      });
}
