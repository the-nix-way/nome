{ pkgs }:

let
  goVersion = pkgs.go_1_19;

  rustVersion = pkgs.rust-bin.stable.latest.default;
in {
  go = {
    tools = [ goVersion ] ++ (with pkgs; [ gotools ]);
  };

  rust = {
    tools = [ rustVersion ] ++ (with pkgs; [ cargo-audit cargo-deny cargo-cross openssl pkg-config rust-analyzer ]);
  };
}
