{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.man.enable = false;
  programs.home-manager.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    defaultCacheTtl = 600;
    maxCacheTtl = 7200;
  };

  imports = [
    ./modules/fish.nix
    ./modules/git
    ./modules/packages.nix
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
      # nb configuration
      NB_DIR = "$HOME/.local/nb";
      NBRC_PATH = "$HOME/.config/nb/nbrc";
      NB_AUTO_SYNC = "1";
    };

    file = {
      ".config/helix".source = ./config/helix;

      # Ghostty terminal configuration
      ".config/ghostty/config".text = ''
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
}
