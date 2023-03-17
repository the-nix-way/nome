{ homeDirectory
, pkgs
, stateVersion
, system
, username
}:

let
  # The packages to load into the PATH
  packages = import ./packages.nix { inherit homeDirectory pkgs; };
in
{
  # Fonts config
  fonts = { fontconfig = { enable = true; }; };

  # Basic Home Manager config
  home = { inherit homeDirectory packages stateVersion username; };

  # Nixpkgs config
  nixpkgs = import ./nixpkgs.nix;

  # Configurations for programs directly supported by Home Manager
  programs = import ./programs.nix { inherit homeDirectory pkgs; };
}
