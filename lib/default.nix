{ pkgs }:

let
  inherit (pkgs.lib) optionals;
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  dev = {
    # Add to list only if on a specific system type
    darwinOnly = ls: optionals isDarwin ls;
    linuxOnly = ls: optionals isLinux ls;

    # Infer home directory based on system
    homeDirectory = username:
      if optionals isDarwin then "/Users/${username}" else "/home/${username}";
  };
}
