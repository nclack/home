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
  ];

  home = {
    stateVersion = "24.05"; # NOTE: changed this between whorl and oreb
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
