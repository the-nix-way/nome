{ pkgs }:

let
  # aarch64-darwin or x86_64-darwin
  darwinSystem = pkgs.stdenv.hostPlatform.system;
  # s/darwin/linux
  linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ]
    darwinSystem;

  dataDir = "/var/lib/nixos-builder";
  system = linuxSystem; # {x86_64|aarch64}-linux
  port = 31022;
in
rec {
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

  builderMachine = {
    hostName = "ssh://linux-builder";
    maxJobs = 4;
    # This is cheating: KVM isn't actually available (?) but QEMU falls back to "slow mode" in this case
    supportedFeatures = [ "kvm" ];
    system = linuxSystem; # {x86_64|aarch64}-linux
  };

  script =
    let
      name = "run-linux-builder";
      bin = pkgs.writeShellScriptBin name ''
        set -uo pipefail
        trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
        IFS=$'\n\t'
        mkdir -p "${dataDir}"
        cd "${dataDir}"
        ${builder}/bin/create-builder
      '';
    in
    "${bin}/bin/${name}";

  logPath = "/var/log/linux-builder.log";
  inherit dataDir port;
}
