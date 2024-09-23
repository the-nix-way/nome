{ pkgs
, username
}:

let
  nixProfile = "/etc/profiles/per-user/${username}/bin";
  swBin = "/run/current-system/sw/bin";
  cargoBin = "$HOME/.cargo/bin";
in
{
  PATH = "${nixProfile}:${swBin}:${cargoBin}:$PATH";
}
