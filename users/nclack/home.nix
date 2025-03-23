{
  lib,
  config,
  ...
}: {
  programs.home-manager.enable = true;

  imports = [
    ./lib/fish.nix
    ./lib/git
    ./lib/packages.nix
    ./lib/hyprland.nix
  ];

  home = {
    stateVersion = "24.11"; # NOTE: changed this between whorl and oreb
    username = "nclack";
    homeDirectory = "/home/nclack";

    sessionVariables = {
      EDITOR = "hx";
    };

    file = {
      "./.config/helix".source = ./config/helix;
    };
  };
}
