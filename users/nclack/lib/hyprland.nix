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
    systemd.enable = true;
    xwayland.enable = true;
    package = null; # Let the system-level package handle this
    portalPackage = null; # Let the system-level package handle this
    settings = {
      # Add basic Hyprland configuration
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
      };
      decoration = {
        rounding = 5;
      };
      input = {
        follow_mouse = 1;
      };
    };
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

    # Themes
    catppuccin-gtk
    catppuccin-cursors
    papirus-icon-theme

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

    # Terminals
    ghostty
    kitty

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

    # Waybar dependencies
    wlogout
    playerctl
  ];

  # Create basic Hyprland configuration directory
  xdg.configFile."hypr" = {
    target = "hypr";
    recursive = true;
    source = ../config/hypr;
  };
  xdg.configFile."waybar" = {
    target = "waybar";
    recursive = true;
    source = ../config/waybar;
  };
}
