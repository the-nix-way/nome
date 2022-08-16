{ homeDirectory, pkgs }:

let
  scripts = import ./scripts.nix { inherit (pkgs) writeScriptBin; };

  general = with pkgs; [ comma ];
in
scripts ++ general
