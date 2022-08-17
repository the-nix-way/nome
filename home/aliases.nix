{ homeDirectory }:

{
  # General
  "," = "comma";
  cat = "bat";
  conf = "code ~/.config/nixpkgs";
  dc = "docker compose";
  diff = "diff --color=auto";
  grep = "grep --color=auto";
  szsh = "source ~/.zshrc";

  # Direnv helpers
  da = "direnv allow";
  dr = "direnv reload";

  ## Nix stuff. Inspired by: https://alexfedoseev.com/blog/post/nix-time.

  # Reload the Home Manager configuration (after git push)
  xx =
    "home-manager switch --flake github:the-nix-way/nome && source ${homeDirectory}/.zshrc";

  # Run Nix garbage collection
  xgc = "nix-env --delete-generations old && nix-store --gc";
  nfu = "nix flake update";
}
