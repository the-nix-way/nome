{ eachDefaultSystem, darwinOnly, linuxOnly, pkgs }:

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

  toolchains = {
    elixir =
      let
        darwinDeps = darwinOnly ((with pkgs; [ terminal-notifier ])
          ++ (with pkgs.darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]));
        linuxDeps = with pkgs; [ inotify-tools libnotify ];
      in
      with pkgs; [ elixir ] ++ darwinDeps ++ linuxDeps;

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
