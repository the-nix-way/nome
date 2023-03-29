{ pkgs, ... }:

{
    nixpkgs = { config = { allowUnfree = true; }; };
    home-manager.useGlobalPkgs = true;
    #home-manager.useUserPackages = true;
    home-manager.users.lucperkins = { pkgs, ... }: {
        home = {
            inherit (pkgs) stateVersion;
        };

        home.packages = with pkgs; [ curl neofetch wget ];
        programs = import ./programs.nix { inherit pkgs; };
    };
}