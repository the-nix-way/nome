# Nome

Nome is my **N**ix h**ome**. It encapsulates a range of Nix goodies that I use to declutter and bring order to my entire laptop environment, including:

* My [Home Manager][hm] configuration
* Shell aliases and helper scripts
* Nix functions and overlays that I can apply to my personal projects

## Home Manager configuration

What I run to active my Home Manager configuration:

```shell
nix build "github:the-nix-way/nome#homeConfigurations.lucperkins.activationPackage"
./result/activate
```

## Creating new development environments

I have a helper command that I run pretty much any time I start a new project:

```shell
proj
```

This is an alias for `nix flake init --template github:the-nix-way/nome`, which copies the contents of [`template`](./template/) into the current directory. That includes this `flake.nix`:

```nix
{
  description = "Local dev environment";

  inputs = {
    nome.url = "github:the-nix-way/nome";
  };

  outputs = { self, nome, ... }:
    nome.lib.dev.mkEnv
      (with nome.lib.dev.toolchains; elixir ++ go ++ node ++ protobuf ++ rust);
}
```

This brings a number of toolchains that I use into the Nix shell. In any given project I'm likely to only use one toolchain, so I remove the ones I don't need. So this series of actions gets me precisely what I need on most of my local projects:

1. Run `proj`.
2. Edit the `flake.nix` to remove any toolchains I won't need.
3. Run `direnv allow` to activate the shell environment.

In cases where this template doesn't provide enough granularity, I create a `flake.nix` from scratch. Over time, however, I hope to add personal templates that get me ever closer to not needing to hand-craft my Nix logic.
## Nix helper functions

* `getHomeDirectory {username}`
* `darwinOnly`
* `linuxOnly`

[hm]: https://github.com/nix-community/home-manager
