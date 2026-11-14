{ pkgs }:

{
  enable = true;

  extensions = with pkgs; [
    gh-actions-lock
    gh-cal
    gh-dash
    gh-eco
    gh-markdown-preview
    gh-ost
    gh-screensaver
    gh-stack
  ];
  gitCredentialHelper = {
    enable = true;
    hosts = [ "https://github.com" ];
  };
  settings = {
    aliases = (import ./aliases.nix { inherit pkgs; }).gh;
    editor = "vim";
    git_protocol = "ssh";
    prompt = "enabled";
  };
}
