{ pkgs, rustInitialOverlay }:

let
  goOverlay = self: super: {
    go = super.go_1_19;
  };

  nodeOverlay = self: super: rec {
    nodejs = super.nodejs-18_x;
    yarn = super.yarn.override { inherit nodejs; };
  };

  rustOverlay = self: super: {
    rust = super.rust-bin.stable.latest.default;
  };

  overlays = [ rustInitialOverlay goOverlay nodeOverlay rustOverlay ];

  pkgsCustom = pkgs.override { inherit overlays; };
in
{
  tools = {
    go = with pkgsCustom; [ go gotools ];

    node = with pkgsCustom; [ nodejs yarn ] ++ (with pkgs.nodePackages; [ pnpm ]);

    protobuf = with pkgsCustom; [ buf protobuf ];

    rust = with pkgsCustom; [ rust ] ++ (with pkgsCustom; [
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
