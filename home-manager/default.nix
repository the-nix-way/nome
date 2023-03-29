{ pkgs
, ...
}:

{
  nixpkgs = import ./nixpkgs.nix;

  home-manager = {
    useGlobalPkgs = true;
    users = {
      lucperkins = { pkgs, ... }: {
        home = {
          inherit (pkgs) stateVersion;
          packages = import ./packages.nix { inherit pkgs; };
        };
        programs = import ./programs.nix { inherit pkgs; };
      };
    };
  };
}
