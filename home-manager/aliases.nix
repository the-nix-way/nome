{ pkgs }:

{
  gh = {
    pvw = "pr view --web";
    rvw = "repo view --web";
  };

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
    l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
    whoops = "reset --hard";
    wipe = "commit -s";
    fix = "rebase --exec 'git commit --amend --no-edit -S' -i origin/develop";
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
    tf = "terraform";
    tg = "terragrunt";
    zj = "zellij";
    j = "just";

    # kubectl
    k = "kubectl";
    kx = "kubectx";

    # Direnv helpers
    da = "direnv allow";
    dr = "direnv reload";
    dk = "direnv revoke";

    # Misc
    ff = "fastfetch";

    ## Nix stuff. Inspired by: https://alexfedoseev.com/blog/post/nix-time.

    # Reload the Home Manager configuration (after git push)
    xx = "home-manager switch --flake github:the-nix-way/nome && source ${pkgs.lib.homeDirectory}/.zshrc";

    # Run Nix garbage collection
    xgc = "nix store gc -v";
    xrd = "sudo launchctl unload /Library/LaunchDaemons/systems.determinate.nix-daemon.plist && sudo launchctl load /Library/LaunchDaemons/systems.determinate.nix-daemon.plist";

    # Nix flake helpers
    ndc = "nix develop --command";
    nfc = "nix flake check";
    nfca = "nix flake check --all-systems";
    nfm = "nix flake metadata";
    nfs = "nix flake show";
    nfu = "nix flake update";
    nsn = "nix search nixpkgs";
    old-nix = "nix run github:NixOS/nix/2.27.0 --";

    # processes
    pf = "pgrep -f";

    # hashes
    rnh = "random-nix-hash";
    rsh = "random-sha256-hash";

    yt = "yt-dlp --cookies-from-browser firefox";
    zed = "zeditor";
  };
}
