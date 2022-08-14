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
}
