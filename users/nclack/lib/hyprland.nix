{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  fredoka-one = pkgs.callPackage ./pkgs/fredoka-one.nix {};
in {
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

    # Fonts
    fredoka-one
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

  xdg.configFile."tofi/config" = {
    text = ''
      # Animation
      animation-duration = 0.2
      corner-radius = 8

      # Font
      font = Fredoka One
      font-size = 20

      # Window Style
      horizontal = true
      anchor = top
      width = 100%
      height = 48

      matching-algorithm = normal

      outline-width = 0
      border-width = 0
      min-input-width = 120
      result-spacing = 30
      padding-top = 8
      padding-bottom = 0
      padding-left = 20
      padding-right = 0

      # Text style
      prompt-text = "Can I have a"
      prompt-padding = 30

      # Catppuccin Mocha colors
      background-color = #1e1e2e
      text-color = #cdd6f4

      prompt-background = #313244
      prompt-background-padding = 4, 10
      prompt-background-corner-radius = 12

      input-color = #cdd6f4
      input-background = #45475a
      input-background-padding = 4, 10
      input-background-corner-radius = 12

      alternate-result-background = #313244
      alternate-result-background-padding = 4, 10
      alternate-result-background-corner-radius = 12

      selection-color = #cdd6f4
      selection-background = #89b4fa
      selection-background-padding = 4, 10
      selection-background-corner-radius = 12
      selection-match-color = #f5e0dc

      clip-to-padding = false
    '';
  };
}
