# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  hostname,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./niri.nix
    ../../modules
  ];

  nixpkgs.overlays = [
    (_final: prev: {
      btop = prev.btop.override { cudaSupport = true; };
    })
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    "nvidia.NVreg_RestrictProfilingToAdminUsers=0"
    "nvme_core.default_ps_max_latency_us=0"
  ];

  networking.networkmanager.enable = true;

  services.upower.enable = true;

  networking = {
    hostName = "${hostname}";
    firewall = {
      enable = true;
      # allowedUDPPorts = [];
      allowedTCPPorts = [ 22 ];
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.opentabletdriver.enable = true;

  # Disable NVMe and WiFi runtime power management to prevent D-state hangs
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="nvme", KERNEL=="nvme*", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:c3:00.0", ATTR{power/control}="on"
  '';

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

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    # RTX 5070 (Blackwell) requires open kernel modules
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      amdgpuBusId = "PCI:197:0:0";
      nvidiaBusId = "PCI:196:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  virtualisation.docker.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  # Org-scoped runner: serves any repo in acquire-project that a workflow
  # requests with `runs-on: [self-hosted, gpu]`. Configure which repos can
  # use it via GitHub → org settings → Actions → Runner groups.
  services.github-runners.acquire-project = {
    enable = true;
    url = "https://github.com/acquire-project";
    tokenFile = "/etc/github-runners/acquire-project.token";
    extraLabels = [ "gpu" ];
    extraPackages = with pkgs; [ docker docker-compose ];
    extraEnvironment = {
      DOCKER_HOST = "unix:///var/run/docker.sock";
    };
    serviceOverrides = {
      SupplementaryGroups = [ "docker" ];
    };
  };

  services.github-runners.damacy = {
    enable = true;
    url = "https://github.com/nclack/damacy";
    tokenFile = "/etc/github-runners/damacy.token";
    extraLabels = [ "gpu" "linux" ];
    extraPackages = with pkgs; [ docker docker-compose ];
    extraEnvironment = {
      DOCKER_HOST = "unix:///var/run/docker.sock";
    };
    serviceOverrides = {
      SupplementaryGroups = [ "docker" ];
    };
  };

  services.tailscale.enable = true;

  services.flatpak.enable = true;

  services.gnome.gnome-keyring.enable = false;

  systemd.settings.Manager.DefaultTimeoutStopSec = "15s";

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.hardware.bolt.enable = true;

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
    mesa-demos
    vulkan-tools

    brightnessctl
    acpi

    loupe
    viu
  ];

  programs = {
    fish.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        openssl
        libffi
        bzip2
        xz
        zstd
        libxcrypt
        ncurses
        readline
        sqlite
        tk
        glib
        nss
        nspr
        expat
      ];
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
