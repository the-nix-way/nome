{
  buildGoLinux = self: super: {
    buildGoModule = super.buildGoModule.override {
      go = super.go // {
        CGO_ENABLED = 0;
        GOOS = "linux";
        GOARCH = "arm64";
      };
    };
  };

  # Overlays for dev environments
  go = self: super: {
    go = super.go_1_19;
  };

  node = self: super: rec {
    nodejs = super.nodejs-18_x;
    yarn = super.yarn.override {
      inherit nodejs;
    };
  };

  rust = self: super: {
    rust = super.pkgs.rust-bin.beta.latest.default;
  };
}
