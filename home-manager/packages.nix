{ pkgs }:

let
  ai = with pkgs; [ ];

  basic = with pkgs; [
    findutils
    tree
    unzip
    wget
    zstd
  ];

  bin = import ./bin.nix { inherit pkgs; };

  buildTools = with pkgs; [ cmake ];

  databaseTools = with pkgs; [
    postgresql_18
    redis
    sqlfluff
  ];

  devOpsTools = with pkgs; [
    awscli2
    dive
    flyctl
    k9s
    kubectx
    kubectl
    minikube
    skaffold
  ];

  versionControlTools = with pkgs; [
    difftastic
    git-crypt
    diff-so-fancy
    gitflow
  ];

  jsTools = with pkgs; [
    biome
    bun
    nodejs
    oxlint
    pnpm
  ];

  docsTools = with pkgs; [ zensical ];

  misc = with pkgs; [
    asciinema
    bottom
    btop
    buf
    cue
    curl
    doctl
    duckdb
    duf
    dust
    easy-template
    fastfetch
    ffmpeg
    gleam
    glow
    httpie
    hugo
    hyperfine
    jid
    jj-starship
    jq
    mprocs
    ngrok
    opa
    pinact
    pkg-config
    process-compose
    protobuf
    qemu
    rumdl
    static-web-server
    tailwindcss_4
    typst
    uutils-coreutils
    vhs
    watchexec
    worker-build
    wrk
    yq
    yt-dlp
    zizmor
  ];

  nixTools = with pkgs; [
    dvt
    fh
    flakebom
    flake-checker
    flake-iter
    minnows-cli
    nh
    nixfmt
    nvd
    statix
  ];

  pythonTools = with pkgs; [
    python315
    uv
  ];

  rustTools = with pkgs; [
    rustToolchain
    bacon
    cargo-edit
    cargo-generate
    cargo-machete
    cargo-watch
  ];

  scripts = with pkgs; [
    (writeScriptBin "pk" ''
      if [ $# -eq 0 ]; then
        echo "No process name supplied"
      fi

      for proc in $1; do
        pgrep -f $proc | xargs kill -9
      done
    '')
  ];

  security = with pkgs; [
    certstrap
    cosign
    grype
    pinentry_mac
    syft
  ];
in
ai
++ basic
++ bin
++ buildTools
++ databaseTools
++ devOpsTools
++ docsTools
++ jsTools
++ misc
++ nixTools
++ pythonTools
++ rustTools
++ scripts
++ security
++ versionControlTools
