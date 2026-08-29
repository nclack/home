{pkgs, ...}: let
  kanagawa-flavor = pkgs.fetchFromGitHub {
    owner = "dangooddd";
    repo = "kanagawa.yazi";
    rev = "04985d12842b06bdb3ad5f1b3d7abc631059b7f5";
    hash = "sha256-Yz0zRVzmgbrk0m7OkItxIK6W0WkPze/t09pWFgziNrw=";
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
