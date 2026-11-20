# Home Manager config for the dev VM. It's deliberately separate from the macOS config in
# ../../home-manager and starts out minimal.
{ constants, ... }:

{
  home = {
    inherit (constants) stateVersion username;
    homeDirectory = "/home/${constants.username}";
  };

  programs = {
    home-manager.enable = true;

    # Installs the rex command, its terminfo entry, and its SSH guard
    rex.enable = true;

    # Rex's SSH guard goes in ~/.ssh/config, which Home Manager only writes when this is on
    ssh = {
      enable = true;
      enableDefaultConfig = false;
    };

    zsh.enable = true;
  };

  # A personal Rex server for this account, as a systemd user service. The Mac reaches it over
  # SSH on the tailnet: ssh://<username>@<hostname>
  services.rex.enable = true;
}
