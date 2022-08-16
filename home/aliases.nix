{ homeDirectory }:

{
  # General
  "," = "comma";

  # Direnv helpers
  da = "direnv allow";
  dr = "direnv reload";

  ## Nix stuff. Inspired by: https://alexfedoseev.com/blog/post/nix-time.

  # Reload the Home Manager configuration
  xx =
    "home-manager switch --flake ${homeDirectory}/.config/nixpkgs && source ${homeDirectory}/.zshrc";

  # Run Nix garbage collection
  xgc = "nix-env --delete-generations old && nix-store --gc";
}
