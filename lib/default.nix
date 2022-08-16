{ eachDefaultSystem, pkgs }:

let
  inherit (pkgs.lib) optionals;
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  dev = import ./dev { inherit eachDefaultSystem pkgs; };

  # Helper functions
  funcs = {
    # Add to list only if on a specific system type
    darwinOnly = ls: optionals isDarwin ls;
    linuxOnly = ls: optionals isLinux ls;

    # Infer home directory based on system
    getHomeDirectory = username:
      if optionals isDarwin then "/Users/${username}" else "/home/${username}";
  };
}
