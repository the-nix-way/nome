{ pkgs }:

let
  bin = import ./bin.nix {
    inherit pkgs;
  };

  local = import ./local.nix {
    inherit pkgs;
  };

  buildTools = with pkgs; [
    cmake
  ];

  databaseTools = with pkgs; [ postgresql_15 ];

  devOpsTools = with pkgs; [
    dive
    #doppler
  ];

  gitTools = with pkgs.gitAndTools;
    [ diff-so-fancy git-codeowners gitflow ]
    ++ (with pkgs; [
      difftastic
      git-annex
      git-crypt
    ]);

  kubernetesTools = with pkgs; [
    #kubectx
    #kubectl
    #minikube
  ];

  macTools = with pkgs.darwin.apple_sdk.frameworks; [
    CoreServices
    Foundation
    Security
  ];

  jsTools = (with pkgs; [ ]) ++ (with pkgs.nodePackages; [
    pnpm
    #yarn
  ]);

  monitoring = with pkgs; [
    bottom
    btop
    htop
  ];

  basic = with pkgs; [ coreutils findutils unzip ];

  # I'll categorize these later :)
  misc = with pkgs; [
    fh
    certstrap
    comma
    curl
    elixir
    flyctl
    hugo # for initializing projects
    ijq
    just
    keybase
    libiconv
    ncurses
    neofetch
    ngrok
    nodejs-18_x # for global npm and npx
    openssl
    pikchr
    pinentry_mac
    pkg-config
    podman
    qemu
    reattach-to-user-namespace # for tmux
    riff # from overlay
    #subversion
    tailscale
    temporalCli
    tree
    treefmt
    unison-ucm
    uuidv7
    wget
    #youtube-dl
    yt-dlp
    zstd
  ];

  nixTools = with pkgs; [
    cachix
    flake-checker
    nixfmt
    nixpkgs-fmt
    #nix-init
  ];

  pythonTools = with pkgs; [ python310 ] ++ (with pkgs.python310Packages; [
    httpie
    pip
    #virtualenv
  ]);

  rustTools = with pkgs; [
    rustToolchain # for things like `cargo init`
    rust-analyzer
  ];

  # These are broken on aarch64-darwin but I hope to add them someday
  broken = with pkgs; [
    materialize
  ];
in
bin
++ local
++ buildTools
++ databaseTools
++ devOpsTools
++ gitTools
++ kubernetesTools
++ macTools
++ jsTools
++ monitoring
++ basic
++ misc
++ nixTools
++ pythonTools
++ rustTools
