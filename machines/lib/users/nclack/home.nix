{pkgs,...}:
{
  home = {
    stateVersion = "23.11";
    username = "nclack";
    homeDirectory = "/home/nclack";

    packages = [
      pkgs.fortune
    ];
  };

  programs.home-manager.enable=true;
  
}
