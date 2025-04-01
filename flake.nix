# This flake was initially generated by fh, the CLI for FlakeHub (version 0.1.6)
{
  description = "Nome: my Nix home";

  inputs = {
    fh = { url = "https://flakehub.com/f/DeterminateSystems/fh/*"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-checker = { url = "https://flakehub.com/f/DeterminateSystems/flake-checker/*"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "https://flakehub.com/f/nix-community/home-manager/0"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-darwin = { url = "github:LnL7/nix-darwin/nix-darwin-24.11"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nuenv = { url = "https://flakehub.com/f/DeterminateSystems/nuenv/0.1.*"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs:
    let
      supportedSystems = [ "aarch64-darwin" ];
      forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.self.overlays.default ];
        };
        inherit system;
      });

      stateVersion = "24.11";
      system = "aarch64-darwin";
      username = "lucperkins";
    in
    {
      devShells = forEachSupportedSystem ({ pkgs, system }: {
        default =
          let
            reload = pkgs.writeScriptBin "reload" ''
              set -e
              echo "> Running darwin-rebuild switch..."
              sudo ${inputs.nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild switch --flake .
              echo "> darwin-rebuild switch was successful ✅"
              echo "> Refreshing zshrc..."
              ${pkgs.zsh}/bin/zsh -c "source ${pkgs.lib.homeDirectory}/.zshrc"
              echo "> zshrc was refreshed successfully ✅"
              echo "> macOS config was successfully applied 🚀"
            '';
          in
          pkgs.mkShell {
            name = "nome";
            packages = with pkgs; [
              nixpkgs-fmt
              reload
            ];
          };
      });

      overlays.default = final: prev: {
        # Constant values to pass around
        constants = {
          inherit username system;
        };

        # Extra lib functions
        lib = prev.lib // {
          homeDirectory =
            if (prev.stdenv.isDarwin)
            then "/Users/${username}"
            else "/home/${username}";
        };

        # Packages
        fh = inputs.fh.packages.${system}.default;
        flake-checker = inputs.flake-checker.packages.${system}.default;
        hugo = inputs.nixpkgs-unstable.legacyPackages.${system}.hugo;
        nh = inputs.nixpkgs-unstable.legacyPackages.${system}.nh;
      };

      darwinConfigurations."${username}-${system}" = inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          { system.stateVersion = 1; }
          inputs.self.darwinModules.base
          inputs.home-manager.darwinModules.home-manager
          inputs.self.darwinModules.home-manager
        ];
      };

      darwinModules = {
        base = { pkgs, ... }: import ./nix-darwin/base {
          inherit pkgs;
          overlays = [
            inputs.nuenv.overlays.default
            inputs.self.overlays.default
          ];
        };

        home-manager = { pkgs, ... }: import ./home-manager {
          inherit pkgs stateVersion username;
        };
      };

      templates = import
        ./templates;
    };
}
