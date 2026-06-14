# nix-config

Declarative configuration of NixOS for all my machines

## Prerequisites

Install nix

```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Update settings in /etc/nix/nix.conf

```
build-users-group = nixbld
trusted-users = root skjoedt
experimental-features = nix-command flakes
```

> [!NOTE]
> These settings will be overriden by home manager

Install home manager

```
nix run home-manager/release-25.11 -- init --switch
```

## Getting started

Use the flake helper apps for common workflows:

```
nix run .#build-pc
nix run .#switch-pc
nix run .#build-server
nix run .#eval-darwin
nix run .#switch-darwin
```

`switch-darwin` may prompt for sudo because nix-darwin system activation must run as root.

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
