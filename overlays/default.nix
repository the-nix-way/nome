{
  buildGoLinux = final: prev: {
    buildGoModule = prev.buildGoModule.override {
      go = prev.go // {
        CGO_ENABLED = 0;
        GOOS = "linux";
        GOARCH = "arm64";
      };
    };
  };

  # Overlays for dev environments
  go = final: prev: {
    go = prev.go_1_18;
  };

  node = final: prev: rec {
    nodejs = prev.nodejs-18_x;
    yarn = prev.yarn.override {
      inherit nodejs;
    };
  };

  rust = final: prev: {
    rustToolchain =
      let
        rust = prev.rust-bin;
      in
      if builtins.pathExists ./rust-toolchain.toml then
        rust.fromRustupToolchainFile ./rust-toolchain.toml
      else if builtins.pathExists ./rust-toolchain then
        rust.fromRustupToolchainFile ./rust-toolchain
      else
        rust.stable.latest.default;
  };
}
