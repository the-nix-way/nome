{
  description = "Nome: my Nix Home";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nix-darwin = { url = "github:lnl7/nix-darwin"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    nuenv = { url = "github:DeterminateSystems/nuenv"; inputs.nixpkgs.follows = "nixpkgs"; };
    #detsys = { url = "github:DeterminateSystems/flake"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs =
    { self
    , nixpkgs
    , nix-darwin
    , home-manager
    , rust-overlay
    , nuenv
    , ...
    }:

    let
      username = "lucperkins";
      stateVersion = "22.11";
      cachix = {
        cache = "the-nix-way";
        publicKey = "the-nix-way.cachix.org-1:x0GnA8CHhHs1twmTdtfZe3Y0IzCOAy7sU8ahaeCCmVw=";
      };
      overlays = [
        (import rust-overlay)
        (final: prev: {
          rustToolchain = prev.rust-bin.stable.latest.default;

          homeDirectory =
            if (prev.stdenv.isDarwin)
            then "/Users/${username}"
            else "/home/${username}";

          inherit stateVersion username;
        })
        nuenv.overlays.default
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
          self.darwinModules.caching
          self.darwinModules.linux-builder
          #detsys.darwinModules.linux-builder
          home-manager.darwinModules.home-manager
          ./home-manager
        ];
      };

      darwinModules = {
        base = { pkgs, ... }: import ./nix-darwin/base {
          inherit overlays pkgs;
        };

        caching = { ... }: import ./nix-darwin/caching {
          inherit cachix username;
        };

        # This module is based on this very helpful comment on the NixOS Discourse:
        # https://discourse.nixos.org/t/nixpkgs-support-for-linux-builders-running-on-macos/24313/2
        linuxBuilder = { pkgs, ... }: import ./nix-darwin/linux-builder {
          inherit pkgs;
        };
      };

      nixosConfigurations = rec {
        default = simple;

        simple = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./nixos/configuration.nix ./nixos/hardware-configuration.nix ];
        };
      };

      templates = import ./templates;
    };
}
