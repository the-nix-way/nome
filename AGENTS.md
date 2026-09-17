# Nome

Nome is Luc Perkins' personal Nix configuration for macOS: a [nix-darwin] system config that in turn applies a [Home Manager][hm] config. It is a personal project, not a reusable template.

## Layout

- `flake.nix` — flake inputs, `darwinConfigurations`, the `reload` dev shell, and per-system overlays
- `nix-darwin/` — nix-darwin system modules
- `home-manager/` — Home Manager modules, one file per concern (`vscode.nix`, `git.nix`, `zsh.nix`, `neovim.nix`, `packages.nix`, etc.), plus `scripts/` and `config/`
- `bootstrap.sh` — sets up a machine that has Nix but maybe not flakes

## Working in this repo

- Apply the configuration with `nix develop --command reload`. This rebuilds and switches the nix-darwin system, which applies the Home Manager config.
- Prefer packages and VS Code extensions from Nixpkgs. In `home-manager/vscode.nix`, extensions missing from Nixpkgs use the `vsce` helper with a pinned version and hash.
- Nix files are formatted with `nixfmt`. Keep lists sorted alphabetically where they already are.
- Do not commit unless asked.

[hm]: https://github.com/nix-community/home-manager
[nix-darwin]: https://github.com/nix-darwin/nix-darwin
