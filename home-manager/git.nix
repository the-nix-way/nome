{ pkgs }:

{
  enable = true;

  aliases = (import ./aliases.nix { inherit pkgs; }).git;
  delta = { enable = true; };
  extraConfig = {
    core = {
      editor = "nvim";
      whitespace = "trailing-space,space-before-tab";
    };
    credential.helper = "osxkeychain";
    commit.gpgsign = "true";
    gpg.program = "gpg2";
    init.defaultBranch = "main";
    protocol.keybase.allow = "always";
    pull.rebase = "false";
    user = { signingkey = "16DB1108FB591835"; };
  };
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
  lfs = { enable = true; };
  package = pkgs.gitAndTools.gitFull;
  userEmail = "lucperkins@gmail.com";
  userName = "Luc Perkins";
}
