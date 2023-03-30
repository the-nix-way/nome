# This module is based on this very helpful comment on the NixOS Discourse:
# https://discourse.nixos.org/t/nixpkgs-support-for-linux-builders-running-on-macos/24313/2
{ pkgs }:

let
  # aarch64-darwin or x86_64-darwin
  darwinSystem = pkgs.stdenv.hostPlatform.system;
  # s/darwin/linux
  linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ]
    darwinSystem;

  # Attribute set describing the Linux builder
  linuxBuilder = rec {
    dataDir = "/var/lib/nixos-builder";
    logPath = "/var/log/linux-builder.log";
    system = linuxSystem; # {x86_64|aarch64}-linux
    port = 31022;

    # The builder VM itself
    builder = (import "${pkgs.path}/nixos" {
      system = linuxSystem; # {x86_64|aarch64}-linux
      configuration = ({ modulesPath, lib, ... }: {
        imports = [ "${modulesPath}/profiles/macos-builder.nix" ];
        virtualisation = {
          host.pkgs = pkgs;
          forwardPorts = lib.mkForce [{
            from = "host";
            host.address = "127.0.0.1";
            host.port = port;
            guest.port = 22;
          }];
        };
      });
    }).config.system.build.macos-builder-installer;
  };

  # A Bash script for running the builder
  runLinuxBuilderScript = pkgs.writeShellScriptBin "run-linux-builder" ''
    set -uo pipefail
    trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
    IFS=$'\n\t'
    mkdir -p "${linuxBuilder.dataDir}"
    cd "${linuxBuilder.dataDir}"
    ${linuxBuilder.builder}/bin/create-builder
  '';
in
{
  environment = {
    # SSH configuration
    etc = {
      "nix/ssh_config".text = ''
        Host linux-builder
          User builder
          HostName 127.0.0.1
          Port ${toString linuxBuilder.port}
          IdentityFile ${linuxBuilder.dataDir}/keys/builder_ed25519
          UserKnownHostsFile /etc/nix/ssh_known_hosts
      '';

      "nix/ssh_known_hosts".text = ''
        [127.0.0.1]:31022 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBWcxb/Blaqt1auOtE+F8QUWrUotiC5qBJ+UuEWdVCb
      '';
    };
  };

  launchd.daemons.linux-builder = {
    command = "${runLinuxBuilderScript}/bin/run-linux-builder";
    path = with pkgs; [ "/usr/bin" coreutils nix ];
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = linuxBuilder.logPath;
      StandardErrorPath = linuxBuilder.logPath;
    };
  };

  nix = {
    buildMachines = [{
      hostName = "ssh://linux-builder";
      maxJobs = 4;
      # This is cheating: KVM isn't actually available (?) but QEMU falls back to "slow mode" in this case
      supportedFeatures = [ "kvm" ];
      system = linuxSystem; # {x86_64|aarch64}-linux
    }];
    distributedBuilds = true;
    envVars = { NIX_SSHOPTS = "-F /etc/nix/ssh_config"; }; # See the config above
  };

  # Make sure that the Nix daemon is enabled in the nix-darwin config
  services.nix-daemon.enable = true;
}
