{ homeDirectory
, pkgs
}:

let
  bin = import ./bin.nix {
    inherit homeDirectory pkgs;
  };

  buildTools = with pkgs; [
    bazelisk
    buf
    bun
    cmake
    protobuf
  ];

  configTools = with pkgs; [
    cue
    dhall
  ];

  databaseTools = with pkgs; [ postgresql_14 refinery-cli ];

  devOpsTools = with pkgs; [
    dagger
    dapr-cli
    dive
    doctl
    doppler
    flyctl
    heroku
    packer
    terraform
    terragrunt
  ];

  fonts = with pkgs.nerdfonts;
    [ (override { fonts = [ "CascadiaCode" "FiraCode" "JetBrainsMono" ]; }) ];

  gitTools = with pkgs.gitAndTools;
    [ diff-so-fancy git-codeowners gitflow ]
    ++ (with pkgs; [ difftastic git-annex git-crypt ]);

  javaTools = with pkgs; [
    gradle
    maven
  ];

  kubernetesTools = with pkgs; [
    kubectx
    kubectl
    minikube
    tilt
  ];

  macTools = with pkgs.darwin.apple_sdk.frameworks; [
    CoreServices
    Foundation
    Security
  ];

  # I'll categorize these later :)
  misc = with pkgs; [
    comma
    coreutils
    findutils
    gleam
    htmltest
    hugo
    keybase
    libiconv
    litestream
    ncurses
    nodejs-16_x
    open-policy-agent
    openssl
    pikchr
    pinentry_mac
    pkg-config
    reattach-to-user-namespace # for tmux
    rustup
    skopeo
    sqlite
    statix
    stow
    subversion
    tailscale
    tree
    treefmt
    vale
    vector
    watchexec
    wget
    youtube-dl
    yt-dlp
    zstd
  ];

  nixTools = with pkgs; [ cachix lorri nixfmt nixpkgs-fmt vulnix ];

  pythonTools = with pkgs; [ python39 ] ++ (with pkgs.python39Packages; [ httpie pip virtualenv ]);

  rubyTools = with pkgs; [
    rbenv
  ];

  rustTools = with pkgs; [
    cargo-web
    sqlx-cli
  ];

  virtualizationTools = with pkgs; [ vagrant qemu ];

  wasmTools = with pkgs; [
    binaryen
    wabt
    wapm-cli
    #broken wasm3
    wasm-bindgen-cli
    wasm-pack
    wasm-text-gen
    wasmtime
    wast-refmt
    webassemblyjs-cli
    webassemblyjs-repl
  ];

  # These are broken on aarch64-darwin but I hope to add them someday
  broken = with pkgs; [ deno materialize wasmer ];
in
bin
++ buildTools
++ configTools
++ databaseTools
++ devOpsTools
++ fonts
++ gitTools
++ kubernetesTools
++ macTools
++ misc
++ nixTools
++ pythonTools
++ rustTools
++ virtualizationTools
++ wasmTools
