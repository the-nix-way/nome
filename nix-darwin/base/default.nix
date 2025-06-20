{ overlays
, pkgs
, ...
}:

{
  documentation.enable = true;

  fonts.packages = pkgs.fonts.packages;

  networking.computerName = "${pkgs.constants.username}-${pkgs.constants.system}";

  # Let Determinate Nix handle Nix configuration
  nix.enable = false;

  # TODO: fix this
  determinate-nix.custom = {
    lazy-trees = "true";
  };

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
    inherit overlays;
  };

  programs = {
    ssh = {
      knownHosts = {
        nixbuild = {
          hostNames = [ "eu.nixbuild.net" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
        };
      };
    };

    zsh.enable = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 1;

  users.users.${pkgs.constants.username} = {
    name = pkgs.constants.username;
    home = pkgs.lib.homeDirectory;
    shell = pkgs.zsh;
  };
}
