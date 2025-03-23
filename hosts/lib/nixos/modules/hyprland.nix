{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.services.hyprland-desktop;
in {
  options.services.hyprland-desktop = {
    enable = lib.mkEnableOption "Hyprland desktop environment";
  };

  config = lib.mkIf cfg.enable {
    # Enable Hyprland
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # greetd login manager with tuigreet
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # Desktop portal for Wayland
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      wlr.enable = true;
    };

    # Polkit agent for system authentication
    security.polkit.enable = true;

    # System-level packages required for Hyprland
    environment.systemPackages = with pkgs; [
      # Basic Wayland utilities
      wl-clipboard
      mesa
      libGL
      libGLU
      libdrm
      libgbm

      # Authentication
      polkit_gnome
    ];

    # AppImage support
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
