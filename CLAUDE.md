# NixOS Configuration Guidelines for Claude

## Build Commands
- Build/switch: `sudo nixos-rebuild switch --flake .#hostname`
- Update flake: `nix flake update`
- Build ISO: `nix build .#hostname.iso`
- Development shell: `nix develop` or `nix-shell`

## Linting
- Format Nix files: `nix fmt` 
- Check Nix files: `nix flake check`

## Code Style
- Use Alejandra defaults for formatting
- Follow modular organization:
  - `hosts/` - Machine configurations
  - `users/` - User-specific configs
  - `pkgs/` - Custom packages
- Naming: camelCase for functions, kebab-case for files
- Imports: group by functionality
- Error handling: use descriptive error messages

## Conventions
- Split config by host, extract common modules
- Reuse code through the lib directory
- Document non-obvious configurations
- Keep customizations self-contained when possible