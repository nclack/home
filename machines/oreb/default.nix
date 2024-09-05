# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config,  pkgs, hostname, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      inputs.nixos-cosmic.nixosModules.default
      ./hardware-configuration.nix
      ../lib/nixos
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "${hostname}"; # Define your hostname.  
    networkmanager.enable=true;
    firewall = {
      enable = true;
      # allowedUDPPorts = [];
      allowedTCPPorts = [ 22 ]; 
    };
  };

  services.desktopManager.cosmic.enable=true;
  services.displayManager.cosmic-greeter.enable=true;

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

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	helix
    fish
    google-chrome
    nil # nix language server
    xclip
    xsel
  ];

  programs = {
    fish.enable = true;
    steam.enable = true;
    # command-not-found.enable = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
