{ pkgs }:

{
  # Fancy replacement for cat
  bat = {
    enable = true;
    config = {
      theme = pkgs.themes.bat;
      # Highlight Starlark build files (Bazel, Buck) as Python
      map-syntax = [
        "BUCK:Python"
        "BUILD:Python"
        "PACKAGE:Python"
        "TARGETS:Python"
        "WORKSPACE:Python"
        "*.star:Python"
      ];
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
    syntaxes = { };
    themes.${pkgs.themes.bat} = {
      src = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "tokyonight.nvim";
        rev = "cdc07ac78467a233fd62c493de29a17e0cf2b2b6";
        sha256 = "sha256-a9iRWue7DB7s/wNdxqqB51Jya5P9X6sDftqhdmKggU0=";
      };
      file = "extras/sublime/${pkgs.themes.bat}.tmTheme";
    };
  };

  bottom = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./config/bottom/tokyonight_night.toml);
  };

  # Navigate directory trees
  broot = {
    enable = true;
    enableZshIntegration = true;
  };

  # Easy shell environments
  direnv = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };

  # Replacement for ls
  eza = {
    enable = true;
    enableZshIntegration = true;
  };

  # Fuzzy finder
  fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # GitHub CLI
  gh = import ./gh.nix { inherit pkgs; };

  # But of course
  git = import ./git.nix { inherit pkgs; };

  go.enable = true;

  # GPG config
  gpg.enable = true;

  # Helix editor
  helix = {
    enable = true;

    defaultEditor = true;

    languages = {
      language = [
        {
          name = "rust";
          auto-format = true;
        }
      ];
    };

    settings.theme = pkgs.themes.helix;
  };

  # Configure HM itself
  home-manager.enable = true;

  # JSON parsing on the CLI
  jq = {
    enable = true;
    #colors = {
    #  arrays = "1;37";
    #  false = "0;37";
    #  null = "1;30";
    #  numbers = "0;37";
    #  objects = "1;37";
    #  strings = "0;32";
    #  true = "0;37";
    #};
  };

  # Shiny new version control
  jujutsu = import ./jj.nix { inherit pkgs; };

  # is more
  less.enable = true;

  # For Git rebases and such
  neovim = import ./neovim.nix { inherit pkgs; };

  # Nushell
  nushell.enable = true;

  # Obsidian
  obsidian = {
    enable = true;
    cli.enable = true;
  };

  # Local agents
  opencode = {
    enable = true;
    enableMcpIntegration = true;
    agents = { };
    commands = { };
    context = "";
    extraPackages = with pkgs; [ ];
    settings = { };
    skills = { };
    tools = { };
    tui.theme = pkgs.themes.opencode;
  };

  # ripgrep
  ripgrep.enable = true;

  # ripgrep-all (for binaries and such)
  ripgrep-all.enable = true;

  # Spotify on the CLI
  spotify-player = {
    enable = true;
    settings = {
      theme = pkgs.themes.spotify-player;
    };
    themes =
      let
        repo = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim";
          rev = "cdc07ac78467a233fd62c493de29a17e0cf2b2b6";
          sha256 = "sha256-a9iRWue7DB7s/wNdxqqB51Jya5P9X6sDftqhdmKggU0=";
        };
      in
      (builtins.fromTOML (builtins.readFile "${repo}/extras/spotify_player/tokyonight_night.toml"))
      .themes;
  };

  # SSH
  ssh = {
    enable = true;
    enableDefaultConfig = false;
    package = pkgs.openssh;
  };

  # The provider of my shell aesthetic
  starship = import ./starship.nix { inherit pkgs; };

  # My most-used editor
  vscode = import ./vscode.nix { inherit pkgs; };

  # Zed
  zed-editor = {
    enable = false; # try again later
    enableMcpIntegration = true;
    extensions = [
      "catppuccin-icons"
      "nix"
      "postgres-language-server"
      "sql"
      "tokyo-night"
    ];
    userSettings = {
      theme = pkgs.themes.zed;
    };
  };

  # My fav shell
  zsh = import ./zsh.nix { inherit pkgs; };
}
