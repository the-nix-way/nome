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

  node = self: super:
    let
      nodejs = super.nodejs-18_x;
    in
    {
      inherit nodejs;
      yarn = super.yarn.override {
        inherit nodejs;
      };
    };
}
