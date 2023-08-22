{ pkgs }:

{
  enable = true;
  userName = "Luc Perkins";
  userEmail = "lucperkins@gmail.com";
  package = pkgs.gitAndTools.gitFull;

  delta = { enable = true; };

  lfs = { enable = true; };

  ignores = [
    ".cache/"
    ".DS_Store"
    ".direnv/"
    ".idea/"
    "*.swp"
    "built-in-stubs.jar"
    "dumb.rdb"
    ".elixir_ls/"
    ".vscode/"
    "npm-debug.log"
  ];
  aliases = (import ./aliases.nix { inherit pkgs; }).git;

  extraConfig = {
    core = {
      editor = "nvim";
      whitespace = "trailing-space,space-before-tab";
    };

    commit.gpgsign = "true";
    gpg.program = "gpg2";

    protocol.keybase.allow = "always";
    credential.helper = "osxkeychain";
    pull.rebase = "false";
    init.defaultBranch = "main";

    user = { signingkey = "CED8419FB058467A"; };
  };
}
