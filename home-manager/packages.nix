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
    postgresql_14
    redis
  ];

  devOpsTools = with pkgs; [
    awscli2
    dive
    flyctl
  ];

  gitTools = (with pkgs; [
    difftastic
    git-crypt
  ] ++ (with gitAndTools; [
    diff-so-fancy
    git-codeowners
    gitflow
  ]));

  jsTools = (with pkgs; [
    bun
    deno
  ] ++ (with nodePackages; [
    pnpm
  ]));

  macTools = with pkgs.darwin.apple_sdk.frameworks; [
    CoreServices
    Foundation
    Security
  ];

  docsTools =
    let
      hugo = pkgs.buildGoModule rec {
        pname = "hugo";
        version = "0.126.2";

        src = pkgs.fetchFromGitHub {
          owner = "gohugoio";
          repo = "hugo";
          rev = "refs/tags/v${version}";
          hash = "sha256-ySXnJJJDjZqZkWOiq9ByflfUG6bg+0GSzuXpNnuyMZc=";
        };

        vendorHash = "sha256-VfwiA5LCAJ1pkmMCy/Dcc5bLKkNY1MHtxHcHvKLoWHs=";

        doCheck = false;

        proxyVendor = true;

        tags = [ "extended" ];

        subPackages = [ "." ];

        nativeBuildInputs = with pkgs; [ installShellFiles ];

        ldflags = [ "-s" "-w" "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=nixpkgs" ];
      };
    in
    [ hugo ];

  misc = with pkgs; [
    comma
    cue
    elixir
    elixir-ls
    jelly
    mprocs
    neofetch
    ngrok
    process-compose
    protobuf
    reattach-to-user-namespace # for tmux
    uuidv7
    yt-dlp
  ];

  nixTools = with pkgs; [
    fh
    flake-checker
    nixfmt-classic
    nixpkgs-fmt
  ];

  pythonTools = with pkgs; [ python311 ] ++ (with pkgs.python311Packages; [
    httpie
  ]);

  rustTools = with pkgs; [
    bacon
    rustToolchain
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

  # These are broken on aarch64-darwin but I hope to add them someday
  broken = with pkgs; [
    materialize
  ];
in
basic
++ bin
++ buildTools
++ databaseTools
++ devOpsTools
++ gitTools
++ jsTools
++ macTools
++ misc
++ nixTools
++ pythonTools
++ rustTools
++ scripts
++ security
++ docsTools
