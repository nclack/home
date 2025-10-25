# Modules

This directory contains common NixOS modules that are shared across all hosts.

## Available Modules

### [default.nix](./default.nix)
Aggregates all common modules and sets `allowUnfree = true` for the entire system.

### [ssh.nix](./ssh.nix)
Configures the OpenSSH daemon:
- Enables SSH service
- Allows password authentication

### [locale.nix](./locale.nix)
Sets system locale and regional preferences:
- Timezone: America/Los_Angeles
- Locale: en_US.UTF-8 for all categories
- Keyboard layout: US

### [nix.nix](./nix.nix)
Configures Nix package manager:
- Enables experimental features: `nix-command` and `flakes`

## Usage

All hosts automatically import these modules via `../../modules` in their configuration.

To add a new common module:
1. Create a new `.nix` file in this directory
2. Add it to the imports list in `default.nix`
3. The module will be available to all hosts

## Philosophy

Modules in this directory should:
- Be applicable to all or most hosts
- Contain no host-specific configuration
- Be self-contained and focused on a single concern

Host-specific configuration belongs in `hosts/<hostname>/default.nix` instead.
