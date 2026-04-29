{
  pkgs,
  stateVersion,
  username,
  imports,
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
          # For repos like Nixpkgs
          file.".config/starship-no-jj.toml".text = ''
            "$schema" = 'https://starship.rs/config-schema.json'

            [custom.jj-starship]
            disabled = true

            [git_commit]
            commit_hash_length = 4
            tag_symbol = "🔖 "

            [git_state]
            cherry_pick = "[🍒 PICKING](bold red)"
            format = "[($state($progress_current of $progress_total))]($style) "

            [git_status]
            ahead = "🏎💨"
            behind = "😰"
            conflicted = "🏳"
            deleted = "🗑"
            diverged = "😵"
            modified = "📝"
            renamed = "👅"
            staged = "[++($count)](green)"
            stashed = "📦"
            untracked = "🤷"
          '';

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
        inherit imports;
        programs = import ./programs.nix { inherit pkgs; };
      };
  };
}
