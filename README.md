# nix-config

Declarative configuration of NixOS for all my machines

## Prerequisites

Install nix 

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

> [!IMPORTANT]
>
> The installer will ask if you want to install Determinate Nix. Answer _No_ as it currently conflicts with `nix-darwin`.


## Getting started



> [!NOTE]
> If you're using a git repository, only files in the working tree will be copied to the [Nix Store](https://zero-to-nix.com/concepts/nix-store).
>
> You must run `git add .` first.


## References

My nix config was ~~taking inspiration~~ stolen and simplified from:

- github.com/dustinlyons/nixos-config
- github.com/mitchellh/nixos-config
- github.com/rvillebro/nix-config
- github.com/Misterio77/nix-config
