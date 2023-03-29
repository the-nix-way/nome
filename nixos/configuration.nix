{ pkgs
, ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  environment = {
    systemPackages = with pkgs; [ cachix ];
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    settings = {
      substituters = [ ];
      trusted-public-keys = [ ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub.device = "/dev/sda";
      systemd-boot = {
        enable = true;
        consoleMode = "0";
      };
    };
  };

  users.users.lucperkins = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      starship
      vim
      zsh
    ];
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = true;
      permitRootLogin = "no";
    };

    sshd = {
      enable = true;
    };
  };

  system = {
    stateVersion = "22.05";
  };
}
