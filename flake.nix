{
  description = "My Nix world";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # For nix-darwin stuff
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
    riff.url = "github:DeterminateSystems/riff";
    nix-init.url = "github:nix-community/nix-init";
  };

  outputs =
    { self
    , nixpkgs
    , darwin
    , flake-utils
    , home-manager
    , rust-overlay
    , riff
    , nix-init
    , ...
    }:

    let
      # Constants
      stateVersion = "22.11";
      system = "aarch64-darwin";
      username = "lucperkins";
      macOsSystem = "Lucs-MacBook-Pro";
      homeDirectory = self.lib.getHomeDirectory username;

      # System-specific Nixpkgs
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          xdg = { configHome = homeDirectory; };
        };
        overlays = [
          (import rust-overlay)
          (self: super: {
            riff = riff.packages.${system}.riff;
            nix-init = nix-init.packages.${system}.default;
          })
        ] ++ (with self.overlays; [ go node rust ]);
      };

      # Helper functions
      run = pkg: "${pkgs.${pkg}}/bin/${pkg}";

      # Modules
      home = import ./home { inherit homeDirectory pkgs stateVersion system username; };
    in
    {
      darwinConfigurations.${macOsSystem} = darwin.lib.darwinSystem {
        inherit system;
        modules = [ (import ./nix-darwin) ];
      };

      homeConfigurations.${system} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          home
        ];
      };

      lib = import ./lib {
        inherit pkgs;
        inherit (flake-utils.lib) eachDefaultSystem;
      };

      overlays = import ./overlays;

      templates = rec {
        default = proj;

        proj = {
          path = ./templates/proj;
          description = "Project starter template";
        };

        editorconfig = {
          path = ./templates/editorconfig;
          description = "editorconfig file template";
        };

        nix = {
          path = ./templates/nix;
          description = "Nix template";
        };

        ec = editorconfig;
      };
    }

    //

    # System-specific stuff
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system: {
      nixosConfigurations =
        let
          modules = [
            ./nixos/configuration.nix
            ./nixos/hardware-configuration.nix
          ];
        in
        nixpkgs.lib.nixosSystem {
          inherit modules system;
        };
    })

    //

    flake-utils.lib.eachSystem [ system ] (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.default =
        let
          format = pkgs.writeScriptBin "format" ''
            ${run "nixpkgs-fmt"} **/*.nix
          '';

          reload = pkgs.writeScriptBin "reload" ''
            ${run "nix"} build .#darwinConfigurations.${macOsSystem}.system
            ./result/sw/bin/darwin-rebuild switch --flake .
          '';
          cache =
            let
              cachix = "${pkgs.cachix}/bin/cachix";
              cachixCache = "the-nix-way";
            in
            pkgs.writeScriptBin "cache" ''
              nix flake archive --json \
              | jq -r '.path,(.inputs|to_entries[].value.path)' \
              | ${cachix} push ${cachixCache}

              # Comment this out until I actually have package outputs
              #nix build --json \
              #| jq -r '.[].outputs | to_entries[].value' \
              #| ${cachix} push ${cachixCache}
            '';
        in
        pkgs.mkShell {
          packages = [ cache format reload pkgs.jq ];
        };
    });
}
