{
  pkgs,
  username,
}:

{
  CARGO_NET_GIT_FETCH_WITH_CLI = "true";
  # Specific to FlakeHub dev
  ENVRC_USE_FLAKE = "1";
  LANG = "en_US.UTF-8";
  XDG_CONFIG_HOME = "/Users/${username}/.config";
  XDG_DATA_HOME = "/Users/${username}/.local/share";
}
