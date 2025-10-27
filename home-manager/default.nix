{
  pkgs,
  stateVersion,
  username,
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

            # Claude Desktop config
            "Library/Application Support/Claude/claude_desktop_config.json" = {
              text = builtins.toJSON {
                mcpServers = {
                  determinate-systems-mcp = {
                    type = "stdio";
                    command = pkgs.lib.getExe pkgs.determinate-systems-mcp;
                    args = [ "stdio" ];
                  };
                };
              };
            };
          };
        };
        imports = [ ];
        programs = import ./programs.nix { inherit pkgs; };
      };
  };
}
