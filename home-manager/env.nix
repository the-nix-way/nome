{ pkgs
, username
}:

{
  PATH = "/etc/profiles/per-user/${username}/bin:$PATH";
}
