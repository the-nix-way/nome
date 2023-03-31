{ overlays
, pkgs
, ...
}:

{
  config = {
    environment = { postBuild = ''echo "DONE!"''; };

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

    networking = {
      computerName = "${pkgs.username}-${pkgs.system}";
    };

    nix = {
      package = pkgs.nixVersions.unstable;
      settings = {
        auto-optimise-store = true;
        bash-prompt-prefix = "(nix:$name)\\040";
        build-users-group = "nixbld";
        cores = 10;
        experimental-features = [ "nix-command" "flakes" ];
        extra-experimental-features = [ "repl-flake" ];
        extra-sandbox-paths = [ ];
        extra-nix-path = "nixpkgs=flake:nixpkgs";
        max-jobs = "auto";
        require-sigs = true;
        sandbox = false;
        sandbox-fallback = false;
      };
    };

    nixpkgs = {
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
  };
}
