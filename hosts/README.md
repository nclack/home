This directory contains the builk of the NixOS configuration.



Machines:
* [whorl](./whorl) - A UTM aarch64 virtual machine.

More information:
* [NixOS options search](https://search.nixos.org/options)
* [Nix packages search](https://search.nixos.org/packages)

For example, to switch to whorl's configuration

```bash
sudo nixos-rebuild switch --flake ~/.config/nix/machines#whorl
```
