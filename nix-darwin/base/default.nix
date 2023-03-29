{ cachix
, overlays
, pkgs
, system
, ...
}:

let
  inherit (pkgs) username;

  # Linux system for the aarch64-linux builder
  linuxBuilder = rec {
    dataDir = "/var/lib/nixos-builder";
    name = builtins.replaceStrings [ "darwin" ] [ "linux" ]
      pkgs.stdenv.hostPlatform.system;
    port = 31022;
    builder = (import "${pkgs.path}/nixos" {
      system = name;
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

  runLinuxBuilder = pkgs.writeShellScriptBin "run-linux-builder" ''
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
    variables = { BOOPER = "bopper"; };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      recursive
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
        ];
      })
    ];
  };

  launchd.daemons.linux-builder = {
    command = "${runLinuxBuilder}/bin/run-linux-builder";
    path = with pkgs; [ "/usr/bin" coreutils nix ];
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/linux-builder.log";
      StandardErrorPath = "/var/log/linux-builder.log";
    };
  };

  nix = {
    buildMachines = [{
      hostName = "ssh://linux-builder";
      system = linuxBuilder.name;
      maxJobs = 4;
      # This is cheating: KVM isn't actually available (?) but QEMU falls back to "slow mode" in this case
      supportedFeatures = [ "kvm" ];
    }];
    distributedBuilds = true;
    envVars = { NIX_SSHOPTS = "-F /etc/nix/ssh_config"; }; # For the Linux builder
    package = pkgs.nixVersions.unstable;
    settings = {
      auto-optimise-store = true;
      bash-prompt-prefix = "(nix:$name)\040";
      build-users-group = "nixbld";
      cores = 10;
      experimental-features = [ "nix-command" "flakes" ];
      extra-sandbox-paths = [ ];
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      max-jobs = "auto";
      require-sigs = true;
      sandbox = false;
      sandbox-fallback = false;
      substituters = [
        "https://cache.nixos.org"
        "https://${cachix.cache}.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        cachix.publicKey
      ];
      trusted-substituters = [ "https://cache.nixos.org" "https://the-nix-way.cachix.org" ];
      trusted-users = [ "root" username ];
    };
  };

  nixpkgs = {
    inherit system;
    config = {
      allowUnfree = true;
    };
    inherit overlays;
  };

  programs = {
    nix-index = {
      enable = true;
    };
    zsh.enable = true;
  };

  services.nix-daemon.enable = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  security.pam.enableSudoTouchIdAuth = true;

  users.users.lucperkins = { name = "lucperkins"; home = pkgs.homeDirectory; };
}
