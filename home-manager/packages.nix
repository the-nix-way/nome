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

  databaseTools = with pkgs; [ postgresql_14 ];

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
    neofetch
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

  security = with pkgs; [
    certstrap
    pinentry_mac
  ];

  shells = with pkgs; [
    nushell
  ];

  # The provider of my shell aesthetic
  starship = import ./starship.nix { inherit pkgs; };

  # My most-used multiplexer
  tmux = import ./tmux.nix;

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
++ security
++ shells
