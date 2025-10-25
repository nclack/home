{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.man.enable = false;
  programs.home-manager.enable = true;

  imports = [
    ./lib/fish.nix
    ./lib/git
    ./lib/packages.nix
  ];

  home = {
    stateVersion = "24.11"; # NOTE: changed this between whorl and oreb
    username = "nclack";
    homeDirectory = "/home/nclack";

    sessionVariables = {
      EDITOR = "hx";
      # Force dark mode for GTK applications
      GTK_THEME = "Adwaita:dark";
      # Fix Electron apps in Wayland
      NIXOS_OZONE_WL = "1";
    };

    file = {
      "./.config/helix".source = ./config/helix;
      
      # Ghostty terminal configuration
      "./.config/ghostty/config".text = ''
        # Catppuccin Mocha theme
        font-size = 11
        
        # Add transparency (90% opaque)
        background-opacity = 0.9
        
        # Match Hyprland blur aesthetics
        window-decoration = false
        window-theme = dark
      '';
    };
  };

  # GTK theme configuration for dark mode
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # Add dconf settings for Nemo
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/cinnamon/desktop/interface" = {
      gtk-theme = "Catppuccin-Mocha-Standard-Blue-Dark";
      icon-theme = "Papirus-Dark";
    };
  };
}
