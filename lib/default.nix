{ eachDefaultSystem, pkgs }:

let
  inherit (pkgs.lib) optionals;
  inherit (pkgs.stdenv) isDarwin isLinux;
in rec {
  # Add to list only if on a specific system type
  darwinOnly = ls: optionals isDarwin ls;
  linuxOnly = ls: optionals isLinux ls;

  # Infer home directory based on system
  getHomeDirectory = username:
    if isDarwin then "/Users/${username}" else "/home/${username}";

  # Make a custom dev environment
  mkEnv = { toolchains ? [ ], extras ? [ ], shellHook ? "" }:
    eachDefaultSystem (system: {
      devShells.default = pkgs.mkShell {
        buildInputs = toolchains ++ extras;
        inherit shellHook;
      };
    });

  # The toolchains that I commonly use
  toolchains = import ./toolchains { inherit darwinOnly linuxOnly pkgs; };
}
