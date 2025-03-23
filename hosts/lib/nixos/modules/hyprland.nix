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
    
    # Environment variables for better app appearance
    environment.sessionVariables = {
      # Electron apps
      NIXOS_OZONE_WL = "1";
      # QT apps
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      # GTK apps
      GDK_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };

    # greetd login manager with tuigreet
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # Custom catppuccin mocha theme colors
          # Enable user-menu and remember last user
          # Display time
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --cmd Hyprland \
              --time \
              --remember \
              --remember-user-session \
              --user-menu \
              --asterisks \
              --width 40 \
              --theme "border=yellow;text=lightred;prompt=green;time=magenta;action=lightcyan;button=yellow;container=black;input=lightmagenta"
          '';
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
      hyprpolkitagent
      
      # Theming
      qt5.qtwayland
      qt6.qtwayland
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
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
