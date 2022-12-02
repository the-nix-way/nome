{ pkgs }:

let
  xh = pkgs.rustPlatform.buildRustPackage rec {
    pname = "xh";
    version = "0.17.0";

    buildInputs = pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [ Security ]);

    src = pkgs.fetchFromGitHub {
      owner = "ducaale";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-4rFtbCfx6QFdp62FPjOYAhSWM03g3rXsF4pD22+EhcA=";
    };

    cargoSha256 = "sha256-av/F1FHMd0o9NvwA2Q9mqSd89ZEqmUaVxC+JmSwEHhI=";

    doCheck = false;
  };
in
[ xh ]
