{ pkgs }:

{
  # Fancy replacement for cat
  bat = {
    enable = true;

    extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
    syntaxes = { };
    themes = {
      dracula = {
        src = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "sublime";
          rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
          sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
        };
        file = "Dracula.tmTheme";
      };
    };
  };

  bottom = {
    enable = true;
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
    # Re-enable when Nix versioning issue is sorted
    #nix-direnv.enable = true;
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
  helix = import ./helix.nix { inherit pkgs; };

  # Configure HM itself
  home-manager = {
    enable = true;
  };

  # JSON parsing on the CLI
  jq = {
    enable = true;
    colors = {
      arrays = "1;37";
      false = "0;37";
      null = "1;30";
      numbers = "0;37";
      objects = "1;37";
      strings = "0;32";
      true = "0;37";
    };
  };

  jujutsu = {
    enable = true;
    package = pkgs.jujutsu;
    settings = (builtins.fromTOML (builtins.readFile ./config/jj/config.toml));
  };

  # For Git rebases and such
  neovim = import ./neovim.nix {
    inherit (pkgs) vimPlugins;
  };

  # Mostly for use with comma
  nix-index = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.nix-index;
  };

  # Nushell
  nushell = {
    enable = true;
  };

  # ripgrep
  ripgrep = {
    enable = true;
  };

  # SSH
  ssh = {
    enable = true;
    package = pkgs.openssh;
  };

  # The provider of my shell aesthetic
  starship = import ./starship.nix { inherit pkgs; };

  tmux = import ./tmux.nix;

  # My most-used editor
  vscode = import ./vscode.nix { inherit pkgs; };

  # My fav shell
  zsh = import ./zsh.nix {
    inherit pkgs;
  };
}
