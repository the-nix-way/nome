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
    macosSystem = "Lucs-MacBook-Pro";
    username = "lucperkins";
    systems = [ "aarch64-darwin" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
      inherit system;
      pkgs = import nixpkgs { inherit system; };
    });
  in {
    devShells = forAllSystems ({ pkgs, system }: {
      default = let
        reload = pkgs.writeScriptBin "reload" ''
          # This janky-ish script is necessary because nix-darwin isn't yet fully flake friendly
          ${pkgs.nixFlakes}/bin/nix build \
            .#darwinConfigurations.${macosSystem}.system
          ./result/sw/bin/darwin-rebuild switch --flake .
        '';
      in pkgs.mkShell {
        name = "nome-dev";
        packages = [ reload ];
      };
    });

    darwinConfigurations.${macosSystem} = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        (import ./nix-darwin)
      ];
    };
  };
}
