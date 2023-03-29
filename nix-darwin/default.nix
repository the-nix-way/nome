{ config, pkgs, lib, ... }:

let
  username = "lucperkins";
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
    environment.systemPackages = [ runLinuxBuilder ];

    # Enable remote builds
    nix = {
      package = pkgs.nixFlakes;

      distributedBuilds = true;

      envVars = { NIX_SSHOPTS = "-F /etc/nix/ssh_config"; };

      extraOptions = ''
        auto-optimise-store = true
        bash-prompt-prefix = (nix:$name)\040
        experimental-features = nix-command flakes
        extra-nix-path = nixpkgs=flake:nixpkgs
        trusted-public-keys = the-nix-way.cachix.org-1:x0GnA8CHhHs1twmTdtfZe3Y0IzCOAy7sU8ahaeCCmVw=
        trusted-substituters = https://cache.nixos.org https://the-nix-way.cachix.org
        trusted-users = root ${username}
      '';
      
      useDaemon = true;

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
