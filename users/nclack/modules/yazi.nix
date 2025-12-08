{pkgs, ...}: let
  kanagawa-flavor = pkgs.fetchFromGitHub {
    owner = "dangooddd";
    repo = "kanagawa.yazi";
    rev = "a0b1d9dec31387b5f8a82c96044e6419b6c46534";
    hash = "sha256-nGFiAgVWfq7RkuGGCt07zm3z7ZTGiIPIR319ojPfdUk=";
  };
in {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    flavors = {
      kanagawa = kanagawa-flavor;
    };

    theme = {
      flavor = {
        dark = "kanagawa";
      };
    };
  };
}
