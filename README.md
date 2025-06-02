# Nome

Nome is my **N**ix h**ome**.
It encapsulates a range of Nix goodies that I use to declutter and bring order to my entire laptop environment, including:

- My [nix-darwin] and [Home Manager][hm] configuration
- Shell aliases and helper scripts

What I run to apply my [nix-darwin] configuration (which in turn applies my [Home Manager][hm] config):

```shell
nix develop --command reload
```

That's right: with Nix installed and [flakes enabled][flakes], this is all that I need to run to stand up a new machine according to my exact specifications, including configuration for [Vim](./nix-darwin/home-manager/neovim.nix), [zellij](./nix-darwin/home-manager/zellij.nix), [zsh](./nix-darwin/home-manager/zsh.nix), [Visual Studio Code](./nix-darwin/home-manager/vscode.nix), [Git](./nix-darwin/home-manager/git.nix), and more.
This has enabled me to eliminate [Homebrew] from my machine.

## Scope

I should make it clear that this project is a personal project and not necessarily intended as a blueprint or a reproducible template.
I do hope that you find some inspiration in it, but don't necessarily interpret what you see here as best practices.
It's just an evolving project that I find quite useful and it's meant above all to show what Nix is capable of.

## Bootstrapping

On a machine that has Nix installed but potentially not flakes:

```shell
./bootstrap.sh
```

[flakes]: https://nixos.wiki/wiki/Flakes
[hm]: https://github.com/nix-community/home-manager
[homebrew]: https://brew.sh
[nix-darwin]: https://github.com/LnL7/nix-darwin
