{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Use Hyprland program explicitly from the flake input
  wayland.windowManager.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  home.packages = with pkgs; [
    # Hyprland ecosystem tools
    hypridle
    hyprlock
    hyprpicker
    # hyprsysteminfo
    hyprsunset
    hyprland-qt-support
    hyprcursor
    hyprutils
    hyprlang
    hyprland-qtutils

    # Notification daemon
    swaynotificationcenter

    # Waybar
    waybar

    # Wallpaper tools
    swww
    # wallrizz

    # Application launcher
    tofi

    # Clipboard manager
    clipse

    # File managers
    yazi # TUI
    nemo # GUI

    # Terminal
    ghostty

    # Screenshots
    flameshot
    grim
    slurp

    # Brightness and power management
    brightnessctl

    # Essential utilities for file management
    ffmpeg
    p7zip
    jq
    poppler
    fzf
    zoxide
    imagemagick
  ];

  # Create basic Hyprland configuration directory
  xdg.configFile."hypr" = {
    target = "hypr";
    recursive = true;
    source = ../config/hypr;
  };
}
