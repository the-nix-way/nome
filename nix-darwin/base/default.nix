{
  overlays,
  pkgs,
  ...
}:

{
  documentation.enable = true;

  environment.etc.${pkgs.flake-registry-file}.text =
    let
      entry = id: to: {
        from = {
          inherit id;
          type = "indirect";
        };
        inherit to;
      };

      flakehub =
        id: org: flake: version:
        entry id {
          type = "tarball";
          url = "https://flakehub.com/f/${org}/${flake}/${version}";
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
        (flakehub "dev-templates" "the-nix-way" "dev-templates" "0.1")
        (flakehub "home-manager" "nix-community" "home-manager" "0")
        (flakehub "nix" "DeterminateSystems" "nix-src" "3")
        (flakehub "nix-darwin" "nix-darwin" "nix-darwin" "0")
        (flakehub "nixos-generators" "nix-community" "nixos-generators" "0.1")
        (flakehub "nixpkgs" "DeterminateSystems" "nixpkgs-weekly" "0.1")
        (flakehub "nome" "the-nix-way" "nome" "0.1")
        (flakehub "templates" "DeterminateSystems" "flake-templates" "0.1")
      ];
      version = 2;
    };

  fonts.packages = pkgs.fonts.packages;

  networking.computerName = "${pkgs.constants.username}-${pkgs.constants.system}";

  # Let Determinate Nix handle Nix configuration
  nix.enable = false;

  # Custom Nix settings in /etc/nix/nix.custom.conf
  determinate-nix.customSettings = {
    flake-registry = "/etc/${pkgs.flake-registry-file}";
    extra-experimental-features = [
      "build-time-fetch-tree"
      "parallel-eval"
    ];
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
