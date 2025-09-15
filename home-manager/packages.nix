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
    kubectl
    minikube
  ];

  versionControlTools =
    with pkgs;
    [
      difftastic
      git-crypt
      gitAndTools.diff-so-fancy
      gitAndTools.gitflow
    ]
    ++ (with gitAndTools; [
      diff-so-fancy
      gitflow
    ]);

  jsTools =
    with pkgs;
    [
      biome
      bun
      deno
      nodejs
      oxlint
    ]
    ++ (with nodePackages; [ pnpm ]);

  docsTools = with pkgs; [ antora ];

  # Mostly for use with Helix
  languageServers = with pkgs; [
    astro-language-server # Astro
    bash-language-server # Bash
    beam27Packages.erlang-ls # Erlang
    cuelsp # Cue
    docker-compose-language-service # Docker Compose
    gopls # Go
    haskellPackages.dhall-lsp-server # Dhall
    jq-lsp # jq
    just-lsp # Just
    lldb_20 # Rust debugging
    markdown-oxide # Markdown
    marksman # Markdown
    mesonlsp # Meson
    metals # Scala
    nil # Nix
    nixd # Nix
    nls # Nickel
    nodePackages_latest.vscode-json-languageserver # JSON
    protols # Protobuf
    regols # Rego
    rubyPackages_3_4.ruby-lsp # Ruby
    ruff # Python
    starpls # Starlark
    superhtml # HTML
    svelte-language-server # Svelte
    taplo # TOML
    terraform-ls # Terraform
    tinymist # Typst
    typescript-language-server # TypeScript
    vscode-langservers-extracted # HTML, CSS, JSON, etc.
    vue-language-server # Vue
    wasm-language-tools # WebAssembly
    yaml-language-server # YAML
  ];

  misc = with pkgs; [
    asciinema
    bottom
    btop
    buf
    comma
    cue
    curl
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
    jid
    jq
    lima
    mprocs
    ngrok
    pkg-config
    process-compose
    protobuf
    qemu
    static-web-server
    typst
    uutils-coreutils
    vhs
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
    nixfmt-rfc-style
  ];

  pythonTools = with pkgs; [
    python314
    uv
  ];

  rustTools = with pkgs; [
    rustToolchain
    bacon
    cargo-edit
    cargo-machete
    cargo-watch
    rust-analyzer
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
++ languageServers
++ jsTools
++ misc
++ nixTools
++ pythonTools
++ rustTools
++ scripts
++ security
++ versionControlTools
++ pkgs.unstable
