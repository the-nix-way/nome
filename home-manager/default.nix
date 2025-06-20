{ pkgs
, stateVersion
, username
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = { pkgs, ... }: {
      home = {
        inherit (pkgs.lib) homeDirectory;
        packages = import ./packages.nix { inherit pkgs; };
        sessionPath = [
          "${pkgs.uutils-coreutils}/bin" # Use Rust coreutils
        ];
        sessionVariables = import ./env.nix { inherit pkgs username; };
        shellAliases = (import ./aliases.nix { inherit pkgs; }).shell;
        inherit stateVersion username;
      };
      imports = [ ];
      programs = import ./programs.nix { inherit pkgs; };
    };
  };
}
