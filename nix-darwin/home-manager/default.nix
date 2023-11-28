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
        packages = import ./packages.nix { inherit pkgs; };
        inherit stateVersion;
        shellAliases = (import ./aliases.nix { inherit pkgs; }).shell;
      };
      programs = import ./programs.nix { inherit pkgs; };
    };
  };
}
