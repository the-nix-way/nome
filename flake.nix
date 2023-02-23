{
  description = "My Nix world";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
    riff.url = "github:DeterminateSystems/riff";
  };

  outputs = { self, nixpkgs, darwin, flake-utils, home-manager, rust-overlay, riff }:
    let
      # Constants
      stateVersion = "22.11";
      system = "aarch64-darwin";
      username = "lucperkins";
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
          })
        ] ++ (with self.overlays; [ go node rust ]);
      };

      # Helper functions
      run = pkg: "${pkgs.${pkg}}/bin/${pkg}";

      # Modules
      home = import ./home { inherit homeDirectory pkgs stateVersion system username; };
    in
    {
      darwinConfigurations.${username} = darwin.lib.darwinSystem {
        inherit system;
        modules = [ (import ./nix-darwin) ];
      };

      homeConfigurations = {
        default = "${username}";

        "${username}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            home
          ];
        };
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

    flake-utils.lib.eachDefaultSystem (system:
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
              ${run "nix"} build .#homeConfigurations.${username}.activationPackage
              ./result/activate
            '';
          in
          pkgs.mkShell {
            packages = [ format reload ];
          };

        packages.default = pkgs.dockerTools.buildImage {
          name = "nix-flakes";
          tag = "latest";
          fromImage = pkgs.dockerTools.pullImage {
            imageName = "nixos/nix";
            finalImageName = "nix";
            finalImageTag = "2.12.0pre20220901_4823067";
            imageDigest = "sha256:82da5bfe03f16bb1bc627af74e76b213fa237565c1dcd0b8d8ef1204d0960a59";
            sha256 = "sha256-sMdYw2HtUM5r5PP+gW1xsZts+POvND6UffKvvaxcv4M=";
          };

          config = {
            WorkingDir = "/app";

            Env = [
              "NIXPKGS_ALLOW_UNFREE=1"
            ];
          };
        };
      });
}
