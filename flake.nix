{
  description = "My Nix world";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }: let
    username = "lucperkins";
    systems = [ "aarch64-darwin" ];
    forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f {
      inherit system;
      pkgs = import nixpkgs { inherit system; };
    });
  in {
    devShells = forEachSystem ({ pkgs, system }: {
      default = let
        reload = pkgs.writeScriptBin "reload" ''
          # This janky-ish script is necessary because nix-darwin isn't yet fully flake friendly
          ${pkgs.nixFlakes}/bin/nix build .#darwinConfigurations.${username}-${system}.system
          ./result/sw/bin/darwin-rebuild switch --flake .
        '';
      in pkgs.mkShell {
        name = "nome-dev";
        packages = [ reload ];
      };
    });

    # TODO: allow for multiple systems
    darwinConfigurations."${username}-aarch64-darwin" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        (import ./nix-darwin)
      ];
    };
  };
}
