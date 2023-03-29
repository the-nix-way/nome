{
  description = "Nome: my Nix Home";

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
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, rust-overlay }:
    let
      username = "lucperkins";
      homeDirectory = "/Users/${username}";
      stateVersion = "22.11";
      cachix = {
        cache = "the-nix-way";
        publicKey = "the-nix-way.cachix.org-1:x0GnA8CHhHs1twmTdtfZe3Y0IzCOAy7sU8ahaeCCmVw=";
      };
      overlays = [
        (import rust-overlay)
        (final: prev: {
          rustToolchain = prev.rust-bin.stable.latest.default;

          inherit homeDirectory stateVersion username;
        })
      ];
      macOsSystems = [ "aarch64-darwin" ];
      forEachMacOsSystem = f: nixpkgs.lib.genAttrs macOsSystems (system: f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachMacOsSystem ({ pkgs, system }: {
        default =
          let
            # Helper script for reloading my full config
            reload = pkgs.writeScriptBin "reload" ''
              # This janky-ish script is necessary because nix-darwin isn't yet fully flake friendly
              ${pkgs.nixFlakes}/bin/nix build .#darwinConfigurations.${username}-${system}.system
              ./result/sw/bin/darwin-rebuild switch --flake .
            '';
          in
          pkgs.mkShell {
            name = "nome";
            packages = [ reload ];
          };
      });

      # TODO: allow for multiple systems
      darwinConfigurations."${username}-aarch64-darwin" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          self.darwinModules.base
          home-manager.darwinModules.home-manager
          ./home-manager
        ];
      };

      darwinModules = {
        base = { pkgs, ... }: {
          config = import ./nix-darwin/base {
            system = "aarch64-darwin";
            inherit cachix overlays pkgs;
          };
        };
      };

      templates = import ./templates;
    };
}
