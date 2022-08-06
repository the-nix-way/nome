{ pkgs }:

let
  inherit (pkgs.lib) optionals;
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  darwinOnly = ls: optionals isDarwin ls;
  linuxOnly = ls: optionals isLinux ls;
}
