{ pkgs }:

{
  enable = true;

  package = pkgs.nushell;

  configFile.source = ./config/config.nu;

  envFile.source = ./config/env.nu;
}
