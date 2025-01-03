# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
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
    substituters = ["https://cosmic.cachix.org/"];
    trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
  };

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

  services.flatpak.enable = true;

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Set global systemd service timeout
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

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
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
