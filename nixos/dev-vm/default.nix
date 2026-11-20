# A dev VM that runs in the cloud. I reach it over Tailscale, and work in it through Rex.
{
  config,
  constants,
  pkgs,
  ...
}:

let
  inherit (constants) username;
in
{
  imports = [ ./hardware.nix ];

  documentation.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit constants; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = ./home.nix;
  };

  networking = {
    hostName = constants.dev-vm.hostName;

    firewall = {
      enable = true;
      # Anything on the tailnet can reach every port, so dev servers need no extra rules
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = constants.dev-vm.system;
  };

  programs.zsh.enable = true;

  # There's no password to type, since logins are by SSH key only
  security.sudo.wheelNeedsPassword = false;

  services = {
    openssh = {
      enable = true;
      # TODO: set this to false once the VM is on the tailnet, so that SSH is tailnet-only
      openFirewall = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # Run `sudo tailscale up` once after the first boot to join the tailnet
    tailscale.enable = true;
  };

  system.stateVersion = constants.stateVersion;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    # Keep user services, such as the Rex server, running while I'm logged out
    linger = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUvVH+hwC70lJzPP0mpGT2Oq/XJOH0C5qncj3PPs6Vx"
    ];
    shell = pkgs.zsh;
  };
}
