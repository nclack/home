{
  pkgs,
  ...
}: {
  programs.man.enable = false;
  programs.home-manager.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 600;
    maxCacheTtl = 7200;
  };

  imports = [
    ./modules/fish.nix
    ./modules/git
    ./modules/packages.nix
    ./modules/yazi.nix
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
      ".config/nb".source = ./config/nb;
      ".config/starship.toml".source = ./config/starship.toml;
      ".config/ghostty/config".source = ./config/ghostty/config;

      ".config/git/allowed_signers".text = ''
        nclack@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGUrV6mxvcVbyUk1S1k4ESKsyokMX2LIalgcpliE9Klf
      '';
    };
  };
}
