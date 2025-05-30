{ pkgs }:

{
  # Fancy replacement for cat
  bat = {
    enable = true;
    config.theme = pkgs.themes.bat;
    extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
    syntaxes = { };
    themes.${pkgs.themes.bat} = {
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat";
        rev = "699f60fc8ec434574ca7451b444b880430319941";
        sha256 = "sha256-6fWoCH90IGumAMc4buLRWL0N61op+AuMNN9CAR9/OdI=";
      };
      file = "themes/${pkgs.themes.bat}.tmTheme";
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

  # Ghostty terminal
  #ghostty = import ./ghostty.nix { inherit pkgs; };

  # But of course
  git = import ./git.nix { inherit pkgs; };

  go.enable = true;

  # GPG config
  gpg.enable = true;

  # Helix editor
  helix = import ./helix.nix { inherit pkgs; };

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

  # Zed editor
  zed-editor = import ./zed.nix { inherit pkgs; };

  # Zellij multiplexer
  zellij = import ./zellij.nix { inherit pkgs; };

  # My fav shell
  zsh = import ./zsh.nix { inherit pkgs; };
}
