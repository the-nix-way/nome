{ pkgs, system, ... }:

let
  username = "lucperkins";
in {
  config = {
    nix = {
      buildMachines = [];
      distributedBuilds = true;
      package = pkgs.nixUnstable;
      settings = {
        auto-optimise-store = true;
        bash-prompt-prefix = "(nix:$name)\040";
        build-users-group = "nixbld";
        cores = 10;
        experimental-features = [ "nix-command" "flakes" ];
        extra-sandbox-paths = [];
        extra-nix-path = "nixpkgs=flake:nixpkgs";
        max-jobs = "auto";
        require-sigs = true;
        sandbox = false;
        sandbox-fallback = false;
        substituters = [
          "https://cache.nixos.org"
          "https://the-nix-way.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "the-nix-way.cachix.org-1:x0GnA8CHhHs1twmTdtfZe3Y0IzCOAy7sU8ahaeCCmVw="
        ];
        trusted-substituters = [ "https://cache.nixos.org" "https://the-nix-way.cachix.org" ];
        trusted-users = [ "root" username ];
      };
    };

    nixpkgs = {
      config = {};
      overlays = [];
    };

    services.nix-daemon.enable = true;
  };
}
