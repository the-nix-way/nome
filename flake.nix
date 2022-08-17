{
  description = "My Nix world";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, flake-utils, home-manager, nixpkgs, rust-overlay }:
    let
      # Constants
      stateVersion = "22.11";
      system = "aarch64-darwin";
      username = "lucperkins";
      homeDirectory = self.lib.funcs.getHomeDirectory username;

      # System-specific Nixpkgs
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          xdg = { configHome = homeDirectory; };
        };
        overlays = [ (import rust-overlay) ] ++ (with self.overlays; [ go node rust ]);
      };

      # Inheritance helpers
      inherit (flake-utils.lib) eachDefaultSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
    in
    {
      homeConfigurations.${username} = homeManagerConfiguration {
        inherit pkgs;

        modules =
          [ (import ./home { inherit homeDirectory pkgs stateVersion system username; }) ];
      };

      lib = import ./lib {
        inherit eachDefaultSystem pkgs;
      };

      overlays = import ./overlays;

      templates = {
        default = {
          path = ./template;
          description = "Project starter template";
        };
      };
    };
}
