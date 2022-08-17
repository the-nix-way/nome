{ homeDirectory }:

{
  git = {
    ba = "branch -a";
    bd = "branch -D";
    br = "branch";
    cam = "commit -am";
    co = "checkout";
    cob = "checkout -b";
    ci = "commit";
    cm = "commit -m";
    cp = "commit -p";
    crp = "cherry-pick";
    d = "diff";
    dco = "commit --amend --no-edit --signoff";
    s = "status";
    pr = "pull --rebase";
    st = "status";
    l =
      "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
    whoops = "reset --hard";
    wipe = "commit -s";
    fix = "rebase --exec 'git commit --amend --no-edit -S' -i origin/develop";
  };

  githubCli = {
    pvw = "pr view --web";
    rvw = "repo view --web";
  };

  shell = {
    # General
    "," = "comma";
    cat = "bat";
    conf = "code ~/.config/nixpkgs";
    dc = "docker compose";
    diff = "diff --color=auto";
    grep = "grep --color=auto";
    szsh = "source ~/.zshrc";

    # Direnv helpers
    da = "direnv allow";
    dr = "direnv reload";

    ## Nix stuff. Inspired by: https://alexfedoseev.com/blog/post/nix-time.

    # Reload the Home Manager configuration (after git push)
    xx =
      "home-manager switch --flake github:the-nix-way/nome && source ${homeDirectory}/.zshrc";

    # Run Nix garbage collection
    xgc = "nix-env --delete-generations old && nix-store --gc";
    nfu = "nix flake update";
  };
}
