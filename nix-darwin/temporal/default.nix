{ config, lib, pkgs, ... }:

let
  cfg = config.services.temporal;

  inherit (lib) mkEnableOption mkIf mkOption types;

  temporalCli = pkgs.buildGoModule {
    name = "temporal";
    src = pkgs.fetchFromGitHub {
      owner = "temporalio";
      repo = "cli";
      rev = "v0.7.0";
      sha256 = "sha256-CXbf3B7XLsDFeRzUk9y1jf0F3ex0sLmBFy0YcOPpTjg=";
    };
    vendorSha256 = "sha256-JG9VeCrkU87MQOpZ2rs6cN1N5cgFVu1UT6w1OyGbw90=";
    subPackages = [ "cmd/temporal" ];
  };
in
{
  options.services.temporal = {
    enable = mkEnableOption ''
      Enable running Temporal in the background on your macOS system
    '';

    namespace = mkOption {
      type = types.str;
      description = "Temporal namespaces to create";
      default = "default";
    };

    port = mkOption {
      type = types.int;
      description = "The port on which the Temporal dev server runs";
      default = 7233;
    };

    uiPort = mkOption {
      type = types.int;
      description = "The port on which the Temporal UI is exposed";
      default = cfg.port + 1000;
    };
  };

  config = mkIf cfg.enable {
    launchd.user.agents.temporal = {
      command = ''
        ${temporalCli}/bin/temporal server start-dev \
          --namespace ${cfg.namespace} \
          --port ${cfg.port} \
          --ui-port ${cfg.uiPort}
      '';
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
