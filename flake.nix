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
    in
    {
      homeConfigurations.${username} = homeManagerConfiguration {
        inherit pkgs;

        modules =
          [ (import ./home { inherit homeDirectory pkgs system username; }) ];
      };

      lib = import ./lib { inherit pkgs; rust-overlay = rust-overlay.overlays.default; };

      overlays = import ./overlays;

      templates = {
        default = {
          path = ./template;
          description = "Project starter template";
        };
      };
    };
}
