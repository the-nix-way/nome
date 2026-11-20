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

    # Worktrees
    wa = "worktree add";
    wl = "worktree list";
    wp = "worktree prune";
  };

  shell = {
    # General
    cat = "bat";
    dc = "docker compose";
    diff = "diff --color=auto";
    grep = "grep --color=auto";
    hp = "history -p";
    szsh = "source ~/.zshrc";

    # Git
    gfoma = "git fetch origin; git merge origin/main";
    gfuma = "git fetch upstream; git merge upstream/main";
    gfums = "git fetch upstream; git merge upstream/master";

    # kubectl
    k = "kubectl";

    # Direnv helpers
    da = "direnv allow";
    dr = "direnv reload";
    dk = "direnv revoke";

    # Misc
    ff = "fastfetch";
    # Show how much disk space is left (the home directory's volume)
    disk-space = "df -h ${pkgs.lib.homeDirectory}";

    # Network
    dns-servers = "scutil --dns | grep nameserver | sort -u";
    flush-dns = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";
    # Show everything listening on a TCP port
    listening = "sudo lsof -iTCP -sTCP:LISTEN -n -P";
    local-ip = "ipconfig getifaddr en0";
    public-ip = "curl -s https://icanhazip.com";
    # Renew the DHCP lease on en0 (Wi-Fi)
    renew-lease = "sudo ipconfig set en0 DHCP";
    wifi-cycle = "networksetup -setairportpower en0 off; networksetup -setairportpower en0 on";

    # macOS admin
    # Keep the machine awake until Ctrl-C
    awake = "caffeinate -dims";
    battery = "pmset -g batt";
    # Rebuild the Spotlight index
    reindex = "sudo mdutil -E /";
    restart-dock = "killall Dock";
    # Remove the quarantine attribute from a path
    unquarantine = "xattr -dr com.apple.quarantine";

    ## Nix stuff. Inspired by: https://alexfedoseev.com/blog/post/nix-time.

    # Run Nix garbage collection
    xgc = "nix store gc -v";
    xrd = "sudo launchctl unload /Library/LaunchDaemons/systems.determinate.nix-daemon.plist && sudo launchctl load /Library/LaunchDaemons/systems.determinate.nix-daemon.plist";

    # Nix flake helpers
    ndc = "nix develop --command";
    nfa = "nix flake archive";
    nfc = "nix flake check";
    nfca = "nix flake check --all-systems";
    nfl = "nix flake lock";
    nfm = "nix flake metadata";
    nfs = "nix flake show";
    nfu = "nix flake update";
    nsn = "nix search nixpkgs";
    nflr = "nix flake lock --recreate-lock-file";
    upstream-nix = "nix run github:NixOS/nix/2.34.7 --";

    # processes
    pf = "pgrep -f";

    # hashes
    rnh = "random-nix-hash";
    rsh = "random-sha256-hash";

    # misc
    http = "xh";
    rcr = "rex config reload";
    uuidv7 = "python3 -c 'import uuid; print(uuid.uuid7())'";
    wx = "watchexec";
    yt = "yt-dlp --cookies-from-browser firefox";
  };
}
