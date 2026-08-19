{pkgs, ...}: {
  programs.man.enable = false;
  programs.home-manager.enable = true;

  imports = [
    ../nclack/modules/fish.nix
    ../nclack/modules/yazi.nix
  ];

  home.packages = with pkgs; [
    eza
    nano
    prismlauncher
  ];

  # Nano is the maintained Pico-style editor. Keep the familiar command too.
  programs.fish.shellAliases.pico = "nano";

  home = {
    stateVersion = "24.11";
    username = "noah";
    homeDirectory = "/home/noah";

    sessionPath = [
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      EDITOR = "nano";
      GTK_THEME = "Adwaita:dark";
      NIXOS_OZONE_WL = "1";
    };

    file = {
      ".config/starship.toml".source = ../nclack/config/starship.toml;
      ".config/ghostty/config".source = ../nclack/config/ghostty/config;
    };
  };
}
