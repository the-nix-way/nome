{
  config,
  darwin-rebuild,
  lib,
  nvd,
  writeShellApplication,
  zsh,
}:

writeShellApplication {
  name = "reload";
  runtimeInputs = [
    nvd
    zsh
  ];
  # sudo resets PATH, so darwin-rebuild needs to be called by its full path
  runtimeEnv = {
    DARWIN_CONFIG = config;
    DARWIN_REBUILD = lib.getExe darwin-rebuild;
  };
  text = builtins.readFile ./reload.sh;
}
