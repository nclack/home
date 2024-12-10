# hosts/whorl/iso.nix
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    # Include your base whorl configuration
    ./default.nix
  ];

  # Override the hardware-configuration.nix import from default.nix
  disabledModules = [ "./hardware-configuration.nix" ];

  # ISO-specific settings
  isoImage.edition = "whorl-utm";
  
  # Essential tools for installation
  environment.systemPackages = with pkgs; [
    parted
    gptfdisk
    vim
  ];

  # Networking configuration - override the default to avoid conflicts
  networking = lib.mkForce {
    hostName = "whorl-installer";
    networkmanager.enable = true;
    # Disable wireless to avoid conflict with NetworkManager
    wireless.enable = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };

  # Remove specific filesystem mounts
  fileSystems = lib.mkForce {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "size=2G" "mode=755" ];
    };
  };

  # Keep the QEMU guest support but remove specific device configurations
  boot.initrd.availableKernelModules = [
    "xhci_pci" 
    "virtio_pci" 
    "usbhid" 
    "usb_storage"
    "sr_mod"
  ];
  
  # Ensure proper architecture
  nixpkgs.hostPlatform = "aarch64-linux";
}
