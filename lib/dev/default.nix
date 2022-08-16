{ eachDefaultSystem, pkgs }:

let
  lib = import ../;
  inherit (lib.funcs) darwinOnly linuxOnly;
in
{
  mkEnv = tools:
    eachDefaultSystem (system:
      let
        inherit (pkgs) mkShell;
      in
      {
        devShells = {
          default = mkShell {
            buildInputs = tools;
          };
        };
      });

  tools = {
    elixir = with pkgs; [ elixir ]
      ++ darwinOnly ((with pkgs; [ terminal-notifier ]) ++ (with pkgs.darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]))
      ++ linuxOnly (with pkgs; [ inotify-tools libnotify ]);

    go = with pkgs;
      [ go gotools ];

    node = with pkgs; [ nodejs yarn ] ++ (with pkgs.nodePackages; [ pnpm ]);

    protobuf = with pkgs; [ buf protobuf ];

    rust = with pkgs; [
      devRust
      cargo-audit
      cargo-cross
      cargo-deny
      cargo-expand
      cargo-fuzz
      cargo-outdated
      openssl
      pkg-config
      rust-analyzer
    ];
  };
}
