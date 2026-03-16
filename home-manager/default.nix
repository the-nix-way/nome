{
  pkgs,
  stateVersion,
  username,
  modules,
}:

{
  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} =
      { pkgs, ... }:
      {
        home = {
          inherit (pkgs.lib) homeDirectory;
          packages = import ./packages.nix { inherit pkgs; };
          sessionPath = [
            "${pkgs.uutils-coreutils}/bin" # Use Rust coreutils
          ];
          sessionVariables = import ./env.nix { inherit pkgs username; };
          shellAliases = (import ./aliases.nix { inherit pkgs; }).shell;
          inherit stateVersion username;

          file = {
            # Ghostty config
            ".config/ghostty/config" = {
              text = ''
                theme = ${pkgs.themes.ghostty}
              '';
              executable = false;
            };
          };
        };
        nix.package = null; # Make sure Home Manager doesn't overwrite my Nix
        imports = modules;
        programs = import ./programs.nix { inherit pkgs; };
      };
  };
}
