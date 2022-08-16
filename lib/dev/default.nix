{ eachDefaultSystem, pkgs }:

let
  # Here, pkgs has the rust-overlay applied
  localRust = pkgs.rust-bin.beta.latest.default;
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
    go = with pkgs;
      [ go gotools ];

    node = with pkgs; [ nodejs yarn ] ++ (with pkgs.nodePackages; [ pnpm ]);

    protobuf = with pkgs; [ buf protobuf ];

    rust = [ localRust ] ++ (with pkgs; [
      cargo-audit
      cargo-cross
      cargo-deny
      cargo-expand
      cargo-fuzz
      cargo-outdated
      openssl
      pkg-config
      rust-analyzer
    ]);
  };
}
