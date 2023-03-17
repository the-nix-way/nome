{ homeDirectory
, pkgs
}:

let
  bin = import ./bin.nix {
    inherit homeDirectory pkgs;
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
    doppler
  ];

  fonts = with pkgs.nerdfonts;
    [ (override { fonts = [ "CascadiaCode" "FiraCode" "JetBrainsMono" "Iosevka" ]; }) ];

  gitTools = with pkgs.gitAndTools;
    [ diff-so-fancy git-codeowners gitflow ]
    ++ (with pkgs; [
      difftastic
      git-annex
      git-crypt
    ]);

  kubernetesTools = with pkgs; [
    kubectx
    kubectl
    minikube
  ];

  macTools = with pkgs.darwin.apple_sdk.frameworks; [
    CoreServices
    Foundation
    Security
  ];

  jsTools = (with pkgs; [ deno ]) ++ (with pkgs.nodePackages; [
    pnpm
    yarn
  ]);

  monitoring = with pkgs; [
    bottom
    btop
    htop
  ];

  # I'll categorize these later :)
  misc = with pkgs; [
    comma
    coreutils
    findutils
    hugo # for initializing projects
    just
    keybase
    libiconv
    ncurses
    nodejs-18_x # for global npm and npx
    openssl
    pikchr
    pinentry_mac
    pkg-config
    podman
    qemu
    reattach-to-user-namespace # for tmux
    riff # from overlay
    subversion
    tailscale
    tree
    treefmt
    wget
    youtube-dl
    yt-dlp
    zstd
  ];

  nixTools = with pkgs; [
    cachix
    nixfmt
    nixpkgs-fmt
    nix-init
  ];

  pythonTools = with pkgs; [ python310 ] ++ (with pkgs.python310Packages; [
    #httpie
    pip
    virtualenv
  ]);

  rustTools = with pkgs; [
    rustup # for things like `cargo init`
  ];

  # These are broken on aarch64-darwin but I hope to add them someday
  broken = with pkgs; [
    materialize
    ucm # unison programming language
  ];
in
bin
++ local
++ buildTools
++ databaseTools
++ devOpsTools
++ fonts
++ gitTools
++ kubernetesTools
++ macTools
++ jsTools
++ monitoring
++ misc
++ nixTools
++ pythonTools
++ rustTools
