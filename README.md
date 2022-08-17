# Nome

Nome is my **N**ix h**ome**. It encapsulates a range of Nix goodies that I use to bring order to my entire local environment, including:

* My Home Manager configuration
* Shell aliases and helper scripts
* Nix functions and overlays that I can apply to my personal projects

## Home Manager configuration

What I run to active my Home Manager configuration:

```shell
nix build "github:the-nix-way/nome#homeConfigurations.lucperkins.activationPackage"
./result/activate
```
