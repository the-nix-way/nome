{
  description = "Nome: my Nix Home";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nix-darwin = { url = "github:lnl7/nix-darwin"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    nuenv = { url = "github:DeterminateSystems/nuenv"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-checker = { url = "github:DeterminateSystems/flake-checker"; };
    uuidv7 = { url = "git+ssh://git@github.com/DeterminateSystems/uuidv7.git"; };
    #detsys = { url = "github:DeterminateSystems/flake"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs =
    { self
    , nixpkgs
    , nix-darwin
    , home-manager
    , rust-overlay
    , nuenv
    , flake-checker
    , uuidv7
    , ...
    }:

    let
      username = "lucperkins";
      stateVersion = "22.11";
      caches = {
        nixos-org = {
          cache = "https://cache.nixos.org";
          publicKey = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        };
        the-nix-way = {
          cache = "https://the-nix-way.cachix.org";
          publicKey = "the-nix-way.cachix.org-1:x0GnA8CHhHs1twmTdtfZe3Y0IzCOAy7sU8ahaeCCmVw=";
        };
        nix-community = {
          cache = "https://nix-community.cachix.org";
          publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
        };
      };

      overlays = [
        rust-overlay.overlays.default
        (final: prev:
          let
            system = prev.system;
          in
          {
            flake-checker = flake-checker.packages.${system}.default;

            uuidv7 = uuidv7.packages.${system}.default;

            rustToolchain = prev.rust-bin.stable.latest.default;

            homeDirectory =
              if (prev.stdenv.isDarwin)
              then "/Users/${username}"
              else "/home/${username}";

            inherit stateVersion username;

            temporalCli = prev.buildGoModule {
              name = "temporal";
              src = prev.fetchFromGitHub {
                owner = "temporalio";
                repo = "cli";
                rev = "v0.7.0";
                sha256 = "sha256-CXbf3B7XLsDFeRzUk9y1jf0F3ex0sLmBFy0YcOPpTjg=";
              };
              vendorSha256 = "sha256-JG9VeCrkU87MQOpZ2rs6cN1N5cgFVu1UT6w1OyGbw90=";
              subPackages = [ "cmd/temporal" ];
            };
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
          home-manager.darwinModules.home-manager
          ./home-manager
        ];
      };

      darwinModules = {
        base = { pkgs, ... }: import ./nix-darwin/base {
          inherit overlays pkgs;
        };

        caching = { ... }: import ./nix-darwin/caching {
          inherit caches username;
        };

        homebrew-replace = {
          imports = [ ./nix-darwin/homebrew-replace ];
        };

        # This module is based on this very helpful comment on the NixOS Discourse:
        # https://discourse.nixos.org/t/nixpkgs-support-for-linux-builders-running-on-macos/24313/2
        linux-builder = { pkgs, ... }: import ./nix-darwin/linux-builder {
          inherit pkgs;
        };

        temporal = { imports = [ ./nix-darwin/temporal ]; };
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
