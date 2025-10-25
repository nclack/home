# Hosts

This directory contains the bulk of the NixOS configuration, organized by machine.

## Machines

### [oreb](./oreb/)
Laptop running COSMIC desktop environment.
- Architecture: x86_64-linux
- Desktop: COSMIC (from nixpkgs)
- Features: Bluetooth, graphics acceleration, flatpak support

### [gyoll](./gyoll/)
Desktop workstation with NVIDIA GPU running COSMIC desktop.
- Architecture: x86_64-linux
- Desktop: COSMIC (from nixpkgs)
- GPU: NVIDIA with proprietary drivers
- Features: PRIME sync, Razer Thunderbolt dock support, OpenRazer

### [whorl](./whorl/)
ARM64 virtual machine for UTM/QEMU.
- Architecture: aarch64-linux
- Purpose: Minimal VM for testing
- Features: QEMU guest tools, SPICE support

## Building

To switch to a specific host configuration:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

Replace `hostname` with `oreb`, `gyoll`, or `whorl`.

## Common Configuration

All hosts share common modules from `../modules/`:
- SSH configuration
- Locale and timezone settings
- Nix flakes and unfree package settings

Host-specific configuration lives in each host's `default.nix`.

## More Information

- [NixOS Options Search](https://search.nixos.org/options)
- [Nix Packages Search](https://search.nixos.org/packages)
