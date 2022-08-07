{ homeDirectory, pkgs }:

let scripts = import ./scripts.nix { inherit (pkgs) writeScriptBin; };
in scripts
