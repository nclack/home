# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  hostname,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    "acpi_enforce_resources=lax"
  ];

  # Workaround for mt7925e suspend issues: unload WiFi before suspend
  systemd.services.wifi-suspend-workaround = {
    description = "Unload mt7925e WiFi driver before suspend";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/modprobe -r mt7925e";
    };
  };

  systemd.services.wifi-resume-workaround = {
    description = "Reload mt7925e WiFi driver after resume";
    wantedBy = [ "suspend.target" ];
    after = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/modprobe mt7925e";
    };
  };

  networking = {
    hostName = "${hostname}";
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

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "poweroff";
    IdleAction = "ignore";
  };

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["amdgpu" "nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      amdgpuBusId = "PCI:197:0:0";
      nvidiaBusId = "PCI:196:0:0";
      reverseSync.enable = true;
    };
  };

  services.flatpak.enable = true;

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.cosmic-greeter.enableGnomeKeyring = true;

  systemd.settings.Manager.DefaultTimeoutStopSec = "15s";

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.printing.enable = true;

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

  environment.systemPackages = with pkgs; [
    helix
    fish
    google-chrome
    firefox
    nil

    wl-clipboard
    xclip
    xsel

    libusb1
    usbutils
    pciutils
    linuxHeaders

    nvtopPackages.nvidia
    glxinfo
    vulkan-tools

    brightnessctl
    acpi
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
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
