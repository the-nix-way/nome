{ pkgs }:

let
  goVersion = pkgs.go_1_19;
  nodeVersion = pkgs.nodejs-18_x;
  rustVersion = pkgs.rust-bin.stable.latest.default;

  yarn = (pkgs.yarn.override { nodejs = nodeVersion; });
in {
  tools = {
    go = [ goVersion ] ++ (with pkgs; [ gotools ]);

    node = [ nodeVersion yarn ] ++ (with pkgs.nodePackages; [ pnpm ]);

    protobuf = with pkgs; [ buf protobuf ];

    rust = [ rustVersion ] ++ (with pkgs; [
      cargo-audit
      cargo-deny
      cargo-cross
      openssl
      pkg-config
      rust-analyzer
    ]);
  };
}
