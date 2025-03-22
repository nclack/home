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
    # Remove compression settings
    contents = [
      {
        source = ../../.; # Copy the entire flake
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
    (writeScriptBin "install-whorl" (builtins.readFile ./install-whorl.sh))
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

  # Keep only essential kernel modules for QEMU/KVM
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_net"
    "virtio_balloon"
    "virtio_console"
    "virtio_rng" # Add random number generator
    "9p" # For 9P filesystem support
    "9pnet" # For 9P network support
    "9pnet_virtio" # For 9P virtio support
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
