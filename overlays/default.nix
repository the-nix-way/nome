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
    devRust = prev.pkgs.rust-bin.beta.latest.default;
  };
}
