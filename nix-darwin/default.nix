{ config, pkgs, lib, ... }:

let
  dataDir = "/var/lib/nixos-builder";
  linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ]
    pkgs.stdenv.hostPlatform.system;
  outerPkgs = pkgs;
  port = 31022;

  # Using `nixpkgs-unstable` here as `darwin.builder` is a relatively new feature. We want the
  # latest updates.
  linuxBuilder = (import "${pkgs.path}/nixos" {
    system = linuxSystem;
    configuration = ({ modulesPath, lib, ... }: {
      imports = [ "${modulesPath}/profiles/macos-builder.nix" ];
      virtualisation.host.pkgs = outerPkgs;
      virtualisation.forwardPorts = lib.mkForce [{
        from = "host";
        host.address = "127.0.0.1";
        host.port = port;
        guest.port = 22;
      }];
    });
  }).config.system.build.macos-builder-installer;

  runLinuxBuilder = pkgs.writeShellScriptBin "run-linux-builder" ''
    set -uo pipefail
    trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
    IFS=$'\n\t'
    mkdir -p "${dataDir}"
    cd "${dataDir}"
    ${linuxBuilder}/bin/create-builder
  '';
in
{
  config = {
    #
    environment.systemPackages = [ runLinuxBuilder ];

    # Enable remote builds
    nix = {
      distributedBuilds = true;

      buildMachines = [{
        hostName = "ssh://linux-builder";
        system = linuxSystem;
        maxJobs = 4;
        # This is cheating: KVM isn't actually available (?) but QEMU falls back to "slow mode" in
        # this case
        supportedFeatures = [ "kvm" ];
      }];
    };

    # We can't/want to edit /var/root/.ssh/config so instead we create the config at another location
    # and tell ssh to use that instead by modifying NIX_SSHOPTS
    environment.etc = {
      "nix/ssh_config".text = ''
        Host linux-builder
          User builder
          HostName 127.0.0.1
          Port ${toString port}
          IdentityFile ${dataDir}/keys/builder_ed25519
          UserKnownHostsFile /etc/nix/ssh_known_hosts
      '';

      "nix/ssh_known_hosts".text = ''
        [127.0.0.1]:31022 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBWcxb/Blaqt1auOtE+F8QUWrUotiC5qBJ+UuEWdVCb
      '';
    };

    # Tell nix-daemon to use our custom SSH config
    nix.envVars = { NIX_SSHOPTS = "-F /etc/nix/ssh_config"; };

    launchd.daemons = {
      linux-builder = {
        command = "${runLinuxBuilder}/bin/run-linux-builder";
        path = with pkgs; [ "/usr/bin" coreutils nix ];
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/var/log/linux-builder.log";
          StandardErrorPath = "/var/log/linux-builder.log";
        };
      };
    };
  };
}
