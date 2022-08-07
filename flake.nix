{
  description = "My Nix world";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, home-manager, nixpkgs, rust-overlay }:
    let
      # Constants
      homeDirectory = "/Users/${username}";
      stateVersion = "22.11";
      system = "aarch64-darwin";
      username = "lucperkins";

      # System-specific Nixpkgs
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          xdg = { configHome = homeDirectory; };
        };
      };

      # Inheritance helpers
      inherit (home-manager.lib) homeManagerConfiguration;

      # Special version of Nixpkgs with overlays applied
      libPkgs = import nixpkgs {
        inherit system;
        overlays = [ (import rust-overlay) ];
      };
    in {
      homeConfigurations.${username} = homeManagerConfiguration {
        inherit pkgs;

        modules =
          [ (import ./home { inherit homeDirectory pkgs system username; }) ];
      };

      lib = { dev = import ./dev { pkgs = libPkgs; }; };

      templates = {
        default = {
          path = ./template;
          description = "Project starter template";
        };
      };
    };
}
