{ pkgs }:

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
  eza = {
    enable = true;
    enableAliases = true;
  };

  # Fuzzy finder
  fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # GitHub CLI
  gh = {
    enable = true;
    settings = {
      editor = "vim";
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = (import ./aliases.nix { inherit pkgs; }).gh;
    };
  };

  # But of course
  git = import ./git.nix { inherit pkgs; };

  # GPG config
  gpg.enable = true;

  # Configure HM itself
  home-manager = {
    enable = true;
  };

  # JSON parsing on the CLI
  jq.enable = true;

  # Mostly for use with comma
  nix-index = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.nix-index;
  };

  # The provider of my shell aesthetic
  starship = import ./starship.nix { inherit pkgs; };

  # My most-used editor
  vscode = import ./vscode.nix { inherit pkgs; };

  # My fav shell
  zsh = import ./zsh.nix {
    inherit pkgs;
  };
}
