{pkgs, ...}: {
  imports = [../nclack/modules/niri.nix];

  programs.man.enable = false;
  programs.home-manager.enable = true;

  home = {
    stateVersion = "24.11";
    username = "otis";
    homeDirectory = "/home/otis";
    packages = [pkgs.ghostty];

    sessionVariables.NIXOS_OZONE_WL = "1";

    file.".config/ghostty/config".source = ../nclack/config/ghostty/config;
  };
}
