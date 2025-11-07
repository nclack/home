{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      set --export GIT_EDITOR hx
    '';
    shellAliases = {
      ls = "eza";
      find = "fd";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
