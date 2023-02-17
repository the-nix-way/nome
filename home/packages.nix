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
    [ (override { fonts = [ "CascadiaCode" "FiraCode" "JetBrainsMono" ]; }) ];

  gitTools = with pkgs.gitAndTools;
    [ diff-so-fancy git-codeowners gitflow ]
    ++ (with pkgs; [ difftastic git-annex git-crypt ]);

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

  # I'll categorize these later :)
  misc = with pkgs; [
    comma
    coreutils
    findutils
    hugo # for initializing projects
    keybase
    libiconv
    ncurses
    nodejs-18_x # for npm init
    openssl
    pikchr
    pinentry_mac
    pkg-config
    reattach-to-user-namespace # for tmux
    riff
    subversion
    tailscale
    tree
    treefmt
    wget
    youtube-dl
    yt-dlp
    zstd
  ];

  nixTools = with pkgs; [ cachix nixfmt nixpkgs-fmt ];

  pythonTools = with pkgs; [ python39 ] ++ (with pkgs.python39Packages; [ httpie pip virtualenv ]);

  rustTools = with pkgs; [
    rustup
  ];

  # These are broken on aarch64-darwin but I hope to add them someday
  broken = with pkgs; [ materialize ];
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
++ misc
++ nixTools
++ pythonTools
++ rustTools
