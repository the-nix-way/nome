{
  overlays,
  pkgs,
  ...
}:

{
  documentation.enable = true;

  environment.etc."nix/flake-registry.json".text =
    let
      entry = id: to: {
        from = {
          inherit id;
          type = "indirect";
        };
        inherit to;
      };

      flakehub =
        id: org: flake:
        entry id {
          type = "tarball";
          url = "https://flakehub.com/f/${org}/${flake}/*";
        };

      github =
        id: owner: repo:
        entry id {
          type = "github";
          inherit owner repo;
        };
    in
    builtins.toJSON {
      flakes = [
        (github "dev-templates" "the-nix-way" "dev-templates")
        (flakehub "home-manager" "nix-community" "home-manager")
        (flakehub "nix" "DeterminateSystems" "nix-src")
        (flakehub "nix-darwin" "nix-darwin" "nix-darwin")
        (flakehub "nixpkgs" "DeterminateSystems" "nixpkgs-weekly")
        (github "templates" "NixOS" "templates")
      ];
      version = 2;
    };

  fonts.packages = pkgs.fonts.packages;

  networking.computerName = "${pkgs.constants.username}-${pkgs.constants.system}";

  # Let Determinate Nix handle Nix configuration
  nix.enable = false;

  determinate-nix.customSettings = {
    flake-registry = "/etc/nix/flake-registry.json";
  };

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
    inherit overlays;
  };

  programs = {
    ssh = {
      knownHosts = {
        nixbuild = {
          hostNames = [ "eu.nixbuild.net" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
        };
      };
    };

    zsh.enable = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 1;

  users.users.${pkgs.constants.username} = {
    name = pkgs.constants.username;
    home = pkgs.lib.homeDirectory;
    shell = pkgs.zsh;
  };
}
