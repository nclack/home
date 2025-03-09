# NixOS Configuration Repository Guide

## Commands
```bash
# Check flake
nix flake check
# Format code (using Alejandra)
nix fmt
# Enter development shell
nix develop
# Update flake dependencies
nix flake update
# Rebuild NixOS configuration
sudo nixos-rebuild switch --flake /home/nclack/src/home#hostname
```

## Code Style & Conventions
- Nix formatting handled by Alejandra
- Line length: 78-80 characters preferred
- Use descriptive names for modules and options
- Group related options in dedicated files
- Follow functional programming practices
- Use comments to explain complex configurations
- Leverage NixOS modules for reusability

## Repository Structure
- `/hosts/` - Machine-specific configurations
- `/users/` - User configurations with home-manager
- `/docs/` - Documentation and development logs

This repository manages NixOS configurations across multiple hosts using the flake system with home-manager for user-specific settings.