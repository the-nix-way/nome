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
        enableNixpkgsReleaseCheck = false; # until 24.05 is available
        inherit (pkgs) homeDirectory;
        packages = import ./packages.nix { inherit pkgs; };
        sessionVariables = import ./env.nix { inherit pkgs username; };
        shellAliases = (import ./aliases.nix { inherit pkgs; }).shell;
        inherit stateVersion username;
      };
      programs = import ./programs.nix { inherit pkgs; };
    };
  };
}
