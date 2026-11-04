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
      { lib, pkgs, ... }:
      {
        home = {
          # macOS reverts wallpapers that live in the Nix store after a few seconds, so use a copy.
          # The store hash in the filename gives new content a new path, which macOS needs to reload it.
          activation.createScreenshotsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            run mkdir -p "$HOME/Pictures/Screenshots"
          '';

          activation.setWallpaper =
            let
              name = baseNameOf "${pkgs.wallpaper}";
            in
            lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              wallpaper_dir="$HOME/Pictures/nome-wallpaper"
              run mkdir -p "$wallpaper_dir"
              run install -m 644 ${pkgs.wallpaper} "$wallpaper_dir/${name}"
              run ${pkgs.desktoppr}/bin/desktoppr "$wallpaper_dir/${name}" \
                || echo "Couldn't set the wallpaper; continuing"
              run find "$wallpaper_dir" -type f ! -name "${name}" -delete
            '';

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
            "$HOME/go/bin"
            "${pkgs.uutils-coreutils}/bin" # Use Rust coreutils
            "/etc/profiles/per-user/${username}/bin"
            "/run/current-system/sw/bin"
            "$HOME/.cargo/bin"
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
        launchd.agents.clean-rust-targets = {
          enable = true;
          config = {
            LowPriorityIO = true;
            ProcessType = "Background";
            ProgramArguments = [
              (pkgs.lib.getExe (pkgs.callPackage ../nix/clean-rust-targets.nix { }))
            ];
            StandardErrorPath = "/tmp/clean-rust-targets.log";
            StandardOutPath = "/tmp/clean-rust-targets.log";
            StartInterval = 3600;
          };
        };
        nix.package = null; # Make sure Home Manager doesn't overwrite my Nix
        inherit imports;
        programs = import ./programs.nix { inherit pkgs; };
        services.ssh-agent.enable = true;
      };
  };
}
