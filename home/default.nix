{ homeDirectory
, pkgs
, stateVersion
, system
, username
}:

{
  # Basic Home Manager config
  home = {
    inherit homeDirectory packages stateVersion;
  };

  # Configure Nix itself (using an unstable version)
  nix = import ./nix.nix { nix = pkgs.nixUnstable; };

  # The packages to load into the PATH
  packages = import ./packages.nix { inherit homeDirectory pkgs; };

  # Configurations for programs directly supported by Home Manager
  programs = import ./programs.nix { inherit homeDirectory; };
}
