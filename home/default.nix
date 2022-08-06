{
  homeDirectory, pkgs, stateVersion, system, username
}:

let
  packages = import ./packages.nix { inherit homeDirectory pkgs; };

  nixPkg = pkgs.nixUnstable;
in {
  home = {
    inherit homeDirectory packages stateVersion;
  };

  nix = import ./nix.nix { nix = nixPkg; };
}
