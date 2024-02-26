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

  databaseTools = with pkgs; [ postgresql_14 redis ];

  devOpsTools = with pkgs; [
    awscli2
    dive
    flyctl
  ];

  gitTools = (with pkgs; [
    difftastic
    git-crypt
  ] ++ (with gitAndTools; [ diff-so-fancy git-codeowners gitflow ]));

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

  misc = with pkgs; [
    comma
    elixir
    elixir-ls
    mprocs
    neofetch
    ngrok
    process-compose
    reattach-to-user-namespace # for tmux
    yt-dlp
  ];

  nixTools = with pkgs; [
    fh
    flake-checker
    nixfmt
    nixpkgs-fmt
  ];

  pythonTools = with pkgs; [ python311 ] ++ (with pkgs.python311Packages; [
    httpie
  ]);

  rustTools = with pkgs; [
    rustToolchain
  ];

  scripts = with pkgs; [
    (writeScriptBin "pk" ''
      if [ $# -eq 0 ]; then
        echo "No search term supplied"
      fi

      pgrep -f $1 | xargs kill -9
    '')
  ];

  security = with pkgs; [
    certstrap
    pinentry_mac
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
