# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  hostname,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./keyboard.nix
    # common ssh, local and nix settings  (flakes, unfree)
    ../lib/nixos
  ];

  nix.settings = {
    substituters = [
      "https://cosmic.cachix.org/"
      "https://nix-community.cachix.org/"
    ];
    trusted-public-keys = [
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = ["nouveau"];

  networking = {
    hostName = "${hostname}"; # Define your hostname.
    networkmanager.enable = true;
    firewall = {
      enable = true;
      # allowedUDPPorts = [];
      allowedTCPPorts = [22];
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.graphics.enable = true;

  hardware.nvidia = {
    # Using beta drivers to address graphical glitches with stable version
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    # Using closed drivers for better stability with external displays
    open = false;
    nvidiaSettings = true;
    # Disabled for better compatibility with display switching
    nvidiaPersistenced = false;
    dynamicBoost.enable = false;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    # PRIME configuration for hybrid Intel/NVIDIA graphics
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Razer Thunderbolt 4 Dock
  services.hardware.bolt.enable = true;
  hardware.openrazer.enable = true;

  services.flatpak.enable = true;

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  services.xserver = {
    enable = true;
    # displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;
    videoDrivers = ["nvidia"];
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.printing.enable = true;

  # enable sound with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    helix
    fish
    google-chrome
    firefox
    nil # nix language server

    wl-clipboard
    xclip
    xsel

    libusb1
    usbutils
    linuxHeaders
  ];
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  programs = {
    fish.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
