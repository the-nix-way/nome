# Nome

Nome is my **N**ix h**ome**. It encapsulates a range of Nix goodies that I use to declutter and bring order to my entire laptop environment, including:

* My [Home Manager][hm] configuration
* Shell aliases and helper scripts
* Nix functions and overlays that I can apply to my personal projects
* [NixOS](#applying-my-nixos-configuration)

## Home Manager configuration

What I run to activate my Home Manager configuration:

```shell
# Install Nix (if necessary)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
  | sh -s -- install

# Activate my config
nix build "github:the-nix-way/nome#homeConfigurations.lucperkins.activationPackage"
./result/activate
```

That's right: with Nix installed and [flakes enabled][flakes], this is all that I need to run to stand up a new machine according to my exact specifications, including configuration for [Vim](./home/neovim.nix), [tmux](./home/tmux.nix), [zsh](./home/zsh.nix), [Visual Studio Code](./home/vscode.nix), [Git](./home/git.nix), and more. This has enabled me to eliminate [Homebrew] from my machine.

## Creating new development environments

While I use Home Manager to cover my global settings, I strive to provide project-specific settings as much as possible. So I've set up a [Nix flake template](./template) that drops a [`flake.nix`](./template/flake.nix), [`flake.lock`](./template/flake.lock), and [`.envrc`](./template/.envrc) into the current directory. All I have to do is run [`proj`](./home/bin.nix#L39-L41) to initialize that template:

```shell
proj
```

Here's my baseline `flake.nix`:

```nix
{
  description = "Local dev environment";

  inputs = { nome.url = "github:the-nix-way/nome"; };

  outputs = { self, nome, ... }:
    nome.lib.mkEnv {
      # Custom language-specific toolchains that I've assembled
      toolchains = with nome.lib.toolchains; elixir ++ go ++ node ++ protobuf ++ rust;
      # Any additional executables I want loaded into the project
      extras = with nome.pkgs; [ jq ];
      # A custom shell hook to run when the shell is initialized
      shellHook = ''
        echo "Welcome to this Nix-provided project env!"
      '';
    };
}
```

As you can see, the only input in this flake is `nome` itself, which provides everything I need for my dev environments. In any given project I'm likely to only use one toolchain, so I remove the ones I don't need. So this series of actions gets me precisely what I need on most of my local projects:

1. Run `proj`.
2. Edit the `flake.nix` to remove any toolchains I won't need.
3. Run `direnv allow` to activate the shell environment.

In cases where this template doesn't provide enough granularity, I create a `flake.nix` from scratch or use a template from my [`dev-templates`][dev-templates] project, which provides Nix flake templates for a wide variety of languages and platforms. Over time, however, I hope to add personal templates that get me ever closer to not needing to hand-craft my Nix logic or use external templates.

An important side effect of building tools to provide project-specific environments is that I've begun to slowly phase out global executables in favor of project-specific ones. Some tools do need to be globally available, such as Git, jq, curl, and wget, but others don't. Tools like Go, cargo, mix (Elixir), and Node.js should _all_ be project specific, and so I've phased them all out of my global environment.

## NixOS configuration

My Nome flake also exports a [NixOS](./nixos/) configuration that I use for experimentation. To apply that config on any NixOS machine:

```shell
nixos-rebuild switch --flake "github:the-nix-way"
```

## Scope

I should make it clear that this project is a personal project and not necessarily intended as a blueprint or a reproducible template. I do hope that you find some inspiration in it, but don't necessarily interpret what you see here as best practices. It's just an evolving project that I find quite useful and it's meant above all to show what Nix is capable of.

[dev-templates]: https://github.com/the-nix-way/dev-templates
[flakes]: https://nixos.wiki/wiki/Flakes
[hm]: https://github.com/nix-community/home-manager
[homebrew]: https://brew.sh
