{ homeDirectory
, pkgs
}:

{
  # Fancy replacement for cat
  bat.enable = true;

  # Navigate directory trees
  broot = {
    enable = true;
    enableZshIntegration = true;
  };

  # Easy shell environments
  direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
  };

  # Replacement for ls
  exa = {
    enable = true;
    enableAliases = true;
  };

  # Fuzzy finder
  fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # The GitHub CLI
  gh = {
    enable = true;
    settings = {
      editor = "vim";
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        pvw = "pr view --web";
        rvw = "repo view --web";
      };
    };
  };

  # But of course
  git = import ./git.nix { inherit pkgs; };

  # GPG config
  gpg.enable = true;

  # Configure HM itself
  home-manager = {
    enable = true;
    path = "...";
  };

  # JSON parsing on the CLI
  jq.enable = true;

  # make replacement
  just = {
    enable = true;
    enableZshIntegration = true;
  };

  # For Git rebases and such
  neovim = import ./neovim.nix {
    inherit (pkgs) vimPlugins;
  };

  # Speed up nix search functionality
  nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  # Experimental shell
  nushell = { enable = true; };

  # Document conversion
  pandoc = {
    enable = true;
    defaults = { metadata = { author = "Luc Perkins"; }; };
  };

  # The provider of my shell aesthetic
  starship = import ./starship.nix;

  # My most-used multiplexer
  tmux = import ./tmux.nix;

  # My most-used editor
  vscode = import ./vscode.nix { inherit pkgs; };

  # My fav shell
  zsh = import ./zsh.nix {
    inherit homeDirectory;
    inherit (pkgs) substituteAll;
  };
}
