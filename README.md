# NixOS Configuration

Nathan's NixOS configuration using flakes and home-manager.

## Structure

```
.
├── modules/          # Common NixOS modules shared across all hosts
├── hosts/            # Machine-specific configurations
│   ├── oreb/        # Laptop - COSMIC desktop
│   ├── gyoll/       # Desktop - COSMIC desktop with NVIDIA
│   └── whorl/       # ARM64 VM (UTM/QEMU)
├── users/            # User-specific home-manager configurations
│   └── nclack/
│       └── modules/ # Home-manager modules
└── flake.nix        # Main flake configuration
```

## Quick Start

### Build and switch to a configuration:
```bash
sudo nixos-rebuild switch --flake .#hostname
```

Where `hostname` is one of: `oreb`, `gyoll`, or `whorl`

### Update all flake inputs:
```bash
nix flake update
```

### Format Nix files:
```bash
nix fmt
```

### Check configuration:
```bash
nix flake check
```

## Hosts

- **[oreb](./hosts/oreb/)** - Laptop running COSMIC desktop
- **[gyoll](./hosts/gyoll/)** - Desktop with NVIDIA GPU running COSMIC desktop
- **[whorl](./hosts/whorl/)** - ARM64 virtual machine (UTM/QEMU)

See the individual host directories for machine-specific documentation.

## More Information

- [NixOS Options Search](https://search.nixos.org/options)
- [Nix Packages Search](https://search.nixos.org/packages)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.xhtml)
