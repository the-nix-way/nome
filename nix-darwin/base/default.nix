{ overlays
, pkgs
, ...
}:


{
  fonts.packages = with pkgs; [ fira-code jetbrains-mono ];

  networking.computerName = "${pkgs.constants.username}-${pkgs.constants.system}";

  nix.enable = false;

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

  #security.pam.enableSudoTouchIdAuth = true;

  system.stateVersion = 1;

  users.users.${pkgs.constants.username} = {
    name = pkgs.constants.username;
    home = pkgs.lib.homeDirectory;
    shell = pkgs.zsh;
  };
}
