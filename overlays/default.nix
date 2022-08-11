{
  buildGoLinux = self: super: {
    buildGoModule = super.buildGoModule.override {
      go = super.go // {
        GOOS = "linux";
        GOARCH = "arm64";
      };
    };
  };
}
