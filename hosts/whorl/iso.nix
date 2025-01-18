{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ./default.nix
  ];

  # Override the hardware-configuration.nix import from default.nix
  disabledModules = ["./hardware-configuration.nix"];

  # ISO-specific settings
  isoImage = {
    edition = "whorl-utm";
    # Make ISO as minimal as possible
    compressImage = true;
    squashfsCompression = "zstd -Xcompression-level 6";
    # Include the flake in the ISO
    contents = [
      {
        source = ../../.;  # Copy the entire flake
        target = "/etc/nixos/whorl";
      }
    ];
  };

  # Essential tools for installation - keeping only what's absolutely necessary
  environment.systemPackages = with pkgs; [
    parted
    gptfdisk
    vim
    git
    # Add script for automated installation
    (writeScriptBin "install-whorl" ''
      #!${pkgs.bash}/bin/bash
      set -e

      # Default disk is /dev/vda for UTM VMs
      DISK="/dev/vda"
      DEFAULT_PASSWORD="whorl"  # This will be the initial root password

      echo "Starting automated Whorl installation on $DISK..."

      # Partition the disk
      parted -s $DISK -- mklabel gpt
      parted -s $DISK -- mkpart ESP fat32 1MiB 512MiB
      parted -s $DISK -- set 1 esp on
      parted -s $DISK -- mkpart primary 512MiB 100%

      # Format partitions
      mkfs.fat -F 32 -n boot ''${DISK}1
      mkfs.ext4 -L nixos ''${DISK}2

      # Mount partitions
      mount ''${DISK}2 /mnt
      mkdir -p /mnt/boot
      mount ''${DISK}1 /mnt/boot

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

        # UTM-specific settings
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Enable guest additions
        virtualisation.vmware.guest.enable = true;

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
    '')
  ];

  # Networking configuration - override the default to avoid conflicts
  networking = lib.mkForce {
    hostName = "whorl-installer";
    networkmanager.enable = true;
    wireless.enable = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };

  # Minimal tmpfs root
  fileSystems = lib.mkForce {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["size=1G" "mode=755"]; # Reduced from 2G to 1G
    };
  };

  # Keep only essential kernel modules for UTM
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_net"
    "virtio_balloon"
    "virtio_console"
  ];

  # Ensure proper architecture
  nixpkgs.hostPlatform = "aarch64-linux";

  # Disable unnecessary services
  services.xserver.enable = false;
  services.printing.enable = false;
  services.pipewire.enable = false;
  documentation.enable = false;
  documentation.doc.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;
}
