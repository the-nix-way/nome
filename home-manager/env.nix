{
  pkgs,
  username,
}:

let
  nixProfile = "/etc/profiles/per-user/${username}/bin";
  swBin = "/run/current-system/sw/bin";
  cargoBin = "$HOME/.cargo/bin";
in
{
  EDITOR = "nvim";
  LANG = "en_US.UTF-8";
  PATH = "${nixProfile}:${swBin}:${cargoBin}:$PATH";
}
