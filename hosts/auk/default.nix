# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  hostname,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # common ssh, local and nix settings  (flakes, unfree)
    ../../modules
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["amdgpu" "nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;  # RTX 5070 (Blackwell) requires open kernel modules
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME configuration for hybrid graphics
    prime = {
      # Bus IDs from lspci:
      # AMD Radeon 890M: c5:00.0
      # NVIDIA RTX 5070: c4:00.0
      amdgpuBusId = "PCI:197:0:0";  # c5:00.0 in decimal
      nvidiaBusId = "PCI:196:0:0";  # c4:00.0 in decimal

      # Choose one of these modes:
      # offload.enable = true;  # NVIDIA GPU on-demand (better battery)
      # sync.enable = true;     # Always use NVIDIA (better performance)
      reverseSync.enable = true;  # AMD as primary, NVIDIA for specific apps
    };
  };

  services.flatpak.enable = true;

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.cosmic-greeter.enableGnomeKeyring = true;

  # Set global systemd service timeout
  systemd.settings.Manager.DefaultTimeoutStopSec = "15s";

  services.xserver = {
    enable = true;
    # displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.printing.enable = true;

  # enable sound with pipewire
  services.pulseaudio.enable = false;
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

    nvtopPackages.nvidia
    glxinfo
    vulkan-tools
  ];
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  programs = {
    fish.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "65536";
    }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
