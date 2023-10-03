# This module is based on this very helpful comment on the NixOS Discourse:
# https://discourse.nixos.org/t/nixpkgs-support-for-linux-builders-running-on-macos/24313/2
{ pkgs }:

let
  linuxBuilder = import ./builder.nix { inherit pkgs; };
in
{
  config = {
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
      command = linuxBuilder.script;
      path = with pkgs; [ "/usr/bin" coreutils nix ];
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = linuxBuilder.logPath;
        StandardErrorPath = linuxBuilder.logPath;
      };
    };

    nix = {
      #buildMachines = [ linuxBuilder.builderMachine ];
      #distributedBuilds = true;
      #envVars = { NIX_SSHOPTS = "-F /etc/nix/ssh_config"; }; # See the config above
    };

    # Make sure that the Nix daemon is enabled in the nix-darwin config
    services.nix-daemon.enable = true;
  };
}
