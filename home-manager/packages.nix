{ pkgs }:

let
  basic = with pkgs; [
    coreutils
    findutils
    tree
    unzip
    wget
    zstd
  ];

  bin = import ./bin.nix {
    inherit pkgs;
  };

  buildTools = with pkgs; [
    cmake
  ];

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

  versionControlTools = (with pkgs; [
    difftastic
    git-crypt
    jjui
    lazyjj
  ] ++ (with gitAndTools; [
    diff-so-fancy
    gitflow
  ]));

  jsTools = (with pkgs; [
    biome
    bun
    deno
    nodejs
    oxlint
  ] ++ (with nodePackages; [
    pnpm
  ]));

  docsTools = with pkgs; [ antora hugo ];

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
    bottom
    buf
    comma
    cue
    duckdb
    elixir
    elixir-ls
    fastfetch
    gleam
    httpie
    lima
    mprocs
    nh
    neofetch
    ngrok
    process-compose
    protobuf
    reattach-to-user-namespace # for tmux
    typst
    wrk
    jq
    yt-dlp
  ];

  nixTools = with pkgs; [
    ephemera
    fh
    flake-checker
    flake-iter
    linux-builder
    nixfmt-classic
    nixpkgs-fmt
  ];

  pythonTools = with pkgs; [ python314 ];

  rustTools = with pkgs; [
    bacon
    cargo
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
