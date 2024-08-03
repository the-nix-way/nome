{ pkgs
, username
}:

{
  PATH = "/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin:$PATH";
}
