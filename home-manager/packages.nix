{ pkgs }:

let
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
    postgresql_17
    redis
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

  jsTools =
    with pkgs;
    [
      biome
      bun
      nodejs

    ]
    ++ (with nodePackages; [ pnpm ]);

  docsTools = with pkgs; [ ];

  misc = with pkgs; [
    asciinema
    bottom
    btop
    buf
    comma
    cue
    curl
    doctl
    duckdb
    duf
    dust
    easy-template
    elixir
    elixir-ls
    fastfetch
    ffmpeg
    gleam
    glow
    httpie
    hyperfine
    jid
    jq
    mprocs
    ngrok
    pkg-config
    process-compose
    protobuf
    qemu
    rumdl
    static-web-server
    typst
    uutils-coreutils
    vhs
    watchexec
    worker-build
    wrk
    yq
    yt-dlp
  ];

  nixTools = with pkgs; [
    dvt
    fh
    flake-checker
    flake-iter
    nh
    nixfmt
    statix
  ];

  pythonTools = with pkgs; [
    python314
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
basic
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
