{ eachDefaultSystem, pkgs }:

let
  inherit (pkgs.lib) optionals;
  inherit (pkgs.stdenv) isDarwin isLinux;
in
rec {
  # Add to list only if on a specific system type
  darwinOnly = ls: optionals isDarwin ls;
  linuxOnly = ls: optionals isLinux ls;

  # Infer home directory based on system
  getHomeDirectory = username:
    if isDarwin then "/Users/${username}" else "/home/${username}";

  # Make a custom dev environment
  mkEnv =
    { toolchains ? [ ]
    , extras ? [ ]
    , shellHook ? ""
    }:

    eachDefaultSystem (system:
    let
      inherit (pkgs) mkShell;
    in
    {
      devShells = {
        default = mkShell {
          buildInputs = toolchains ++ extras;
          inherit shellHook;
        };
      };
    });

  # The toolchains that I commonly use
  toolchains = {
    elixir =
      let
        darwinDeps = darwinOnly ((with pkgs; [ terminal-notifier ])
          ++ (with pkgs.darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]));
        linuxDeps = linuxOnly (with pkgs; [ inotify-tools libnotify ]);
      in
      with pkgs; [ elixir ] ++ darwinDeps ++ linuxDeps;

    go = with pkgs;
      [ go go2nix gotools ];

    node = with pkgs; [ nodejs yarn ] ++ (with pkgs.nodePackages; [ pnpm ]);

    protobuf = with pkgs; [ buf protobuf ];

    rust = with pkgs; [
      devRust
      cargo-audit
      cargo-cross
      cargo-deny
      cargo-edit
      cargo-expand
      cargo-fuzz
      cargo-make
      cargo-outdated
      cargo-profiler
      openssl
      pkg-config
      rust-analyzer
    ];
  };
}
