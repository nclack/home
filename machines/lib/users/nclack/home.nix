{pkgs, ...}:
{
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable=true;

  imports = [
    ./lib/fish
    ./lib/git
    ./lib/packages.nix
  ];

  home = {
    stateVersion = "23.11";
    username = "nclack";
    homeDirectory = "/home/nclack";

    packages = [
      pkgs.fortune
    ];
  };
}
