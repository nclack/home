#!/usr/bin/env bash
set -e

# Allow overriding the disk device
DISK="${DISK:-/dev/vda}"  # Default for QEMU, but can be overridden
DEFAULT_PASSWORD="whorl"  # This will be the initial root password

# Warn about disk selection
echo "WARNING: Will install to disk $DISK. Press Ctrl+C within 5 seconds to cancel..."
sleep 5

echo "Starting automated Whorl installation on $DISK..."

# Partition the disk
parted -s $DISK -- mklabel gpt
parted -s $DISK -- mkpart ESP fat32 1MiB 512MiB
parted -s $DISK -- set 1 esp on
parted -s $DISK -- mkpart primary 512MiB 100%

# Format partitions
mkfs.fat -F 32 -n boot ${DISK}1
mkfs.ext4 -L nixos ${DISK}2

# Mount partitions
mount ${DISK}2 /mnt
mkdir -p /mnt/boot
mount ${DISK}1 /mnt/boot

# Generate initial config
nixos-generate-config --root /mnt

# Copy the flake to the target system
mkdir -p /mnt/etc/nixos
cp -r /etc/nixos/whorl /mnt/etc/nixos/

# Create a custom configuration.nix
cat > /mnt/etc/nixos/configuration.nix << EOF
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./whorl/hosts/whorl/default.nix
  ];

  # Boot settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # QEMU/KVM guest support
  services.qemuGuest.enable = true;
  
  # Optional: Enable spice-vdagent for better integration
  services.spice-vdagentd.enable = true;

  # Any additional VM-specific settings can go here
}
EOF

# Install NixOS
echo "Installing NixOS..."
nixos-install --no-root-passwd

# Set root password
echo "Setting root password to: $DEFAULT_PASSWORD"
echo "root:$DEFAULT_PASSWORD" | chpasswd -R /mnt

echo "Installation complete!"
echo "You can now:"
echo "1. Reboot the system: 'reboot'"
echo "2. Log in as root with password: $DEFAULT_PASSWORD"
echo "3. Change the root password using 'passwd'" 