{ pkgs }:

{
  enable = true;

  settings = {
    alias = (import ./aliases.nix { inherit pkgs; }).git;
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
    user = {
      email = "lucperkins@gmail.com";
      name = "Luc Perkins";
      signingkey = "0AC42F39CE1FB90F";
    };
  };

  ignores = [
    ".cache/"
    ".DS_Store"
    ".direnv"
    ".idea/"
    ".jj/"
    "*.swp"
    "built-in-stubs.jar"
    "dump.rdb"
    ".elixir_ls/"
    ".vscode/"
    "npm-debug.log"
  ];
  lfs.enable = true;
  package = pkgs.git;
}
