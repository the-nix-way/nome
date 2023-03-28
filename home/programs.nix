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

    stdlib = ''
      use_riff() {
        watch_file Cargo.toml Cargo.lock
        eval "$(riff print-dev-env)"
      }
    '';
  };

  # Replacement for ls
  exa = {
    enable = true;
    enableAliases = true;
  };

  # Fish shell
  #fish = import ./fish.nix { inherit homeDirectory pkgs; };

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
      aliases = (import ./aliases.nix { inherit homeDirectory; }).githubCli;
    };
  };

  # But of course
  git = import ./git.nix { inherit homeDirectory pkgs; };

  # GPG config
  gpg.enable = true;

  # Configure HM itself
  home-manager = {
    enable = true;
  };

  # JSON parsing on the CLI
  jq.enable = true;

  # Kitty terminal emulator
  #kitty = {
  #  enable = true;
  #};

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
  nushell = import ./nushell.nix { inherit pkgs; };

  # Document conversion
  #pandoc = {
  #  enable = true;
  #  defaults = { metadata = { author = "Luc Perkins"; }; };
  #};

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
