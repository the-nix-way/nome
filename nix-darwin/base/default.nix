{
  overlays,
  pkgs,
  ...
}:

{
  documentation.enable = true;

  environment.etc."nix/flake-registry.json".text =
    let
      tarball = id: url: {
        from = {
          inherit id;
          type = "indirect";
        };
        to = {
          type = "tarball";
          inherit url;
        };
      };
    in
    builtins.toJSON {
      flakes = [
        (tarball "home-manager" "https://flakehub.com/f/nix-community/home-manager/*")
        (tarball "minnows" "https://flakehub.com/f/DeterminateSystems/minnows/*")
        (tarball "nix-darwin" "https://flakehub.com/f/nix-darwin/nix-darwin/*")
        (tarball "nixpkgs" "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/*")
        (tarball "templates" "github:NixOS/templates")
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
