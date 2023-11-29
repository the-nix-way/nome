{ overlays
, pkgs
}:

{
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

  networking.computerName = "${pkgs.username}-${pkgs.system}";

  nix = import ./nix.nix;

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
    inherit overlays;
  };

  security.pam.enableSudoTouchIdAuth = true;

  services.nix-daemon.enable = true;

  system = import ./macos.nix { inherit pkgs; };

  users.users.${pkgs.username} = {
    name = pkgs.username;
    home = pkgs.homeDirectory;
  };
}
