{
  config,
  darwin-rebuild,
  lib,
  writeShellApplication,
  zsh,
}:

writeShellApplication {
  name = "reload";
  runtimeInputs = [ zsh ];
  # sudo resets PATH, so darwin-rebuild needs to be called by its full path
  runtimeEnv = {
    DARWIN_CONFIG = config;
    DARWIN_REBUILD = lib.getExe darwin-rebuild;
  };
  text = builtins.readFile ./reload.sh;
}
