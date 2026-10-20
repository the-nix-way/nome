{
  overlays,
  pkgs,
  constants,
  ...
}:

{
  documentation.enable = true;

  environment.etc.${constants.flake-registry-file}.text =
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
        {
          from = {
            id = "fips";
            type = "indirect";
          };
          to = {
            type = "tarball";
            url = "https://fipspkgs.com";
          };
        }
        (flakehub "dev-templates" "the-nix-way" "dev-templates" "0.1")
        (flakehub "fenix" "nix-community" "fenix" "0.1")
        (flakehub "flakehub" "DeterminateSystems" "flakehub" "0.1")
        (flakehub "home-manager" "nix-community" "home-manager" "0")
        (flakehub "minnows" "DeterminateSystems" "minnows" "0.1")
        (flakehub "nix" "DeterminateSystems" "nix-src" "3")
        (flakehub "nix-darwin" "nix-darwin" "nix-darwin" "0")
        (flakehub "nixos-generators" "nix-community" "nixos-generators" "0.1")
        (flakehub "nixpkgs" "DeterminateSystems" "nixpkgs-weekly" "0.1")
        (flakehub "nome" "the-nix-way" "nome" "0.1")
        (flakehub "nuenv" "DeterminateSystems" "nuenv" "0.1")
        (flakehub "pdfs" "DeterminateSystems" "pdfs" "0.1")
        (flakehub "schemas" "DeterminateSystems" "flake-schemas" "0")
        (flakehub "secure-packages" "DeterminateSystems" "secure-packages-rolling" "0.1")
        (flakehub "stable" "NixOS" "nixpkgs" "0")
        (flakehub "templates" "DeterminateSystems" "flake-templates" "0.1")
        (flakehub "unstable" "NixOS" "nixpkgs" "0.1")
      ];
      version = 2;
    };

  fonts.packages = pkgs.fonts.packages;

  networking.computerName = "${constants.username}-${constants.system}";

  # Custom Nix settings in /etc/nix/nix.custom.conf
  determinateNix = {
    # Let Determinate Nix handle Nix configuration
    enable = true;

    shellCompletions.enable = true;

    customSettings = {
      trusted-users = [ constants.username ];
      flake-registry = "/etc/${constants.flake-registry-file}";
      extra-experimental-features = [
        "baked-derivations"
        "build-time-fetch-tree"
        "ca-derivations"
        "cnsa"
        "parallel-eval"
        "provenance"
        "wasm-builtin"
        "wasm-derivations"
      ];
      system-features = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
    };
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

  security = {
    pam.services.sudo_local.touchIdAuth = true;

    # Distrust the roots behind the compromised eMudhra intermediates until Nixpkgs ships NSS >= 3.131.1
    # https://emudhra.we-have-a-problem.com
    pki.caCertificateBlacklist = [
      "Comodo AAA Services root"
      "emSign ECC Root CA - G3"
    ];
  };

  system = {
    # Disable font smoothing (stem darkening) for thinner, crisper text; apps must be relaunched to pick it up
    defaults.NSGlobalDomain.AppleFontSmoothing = 0;
    primaryUser = constants.username;
    stateVersion = 1;
  };

  users.users.${constants.username} = {
    name = constants.username;
    home = pkgs.lib.homeDirectory;
    shell = pkgs.zsh;
  };
}
