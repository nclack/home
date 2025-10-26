{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      set --export GIT_EDITOR hx
      set --export GPG_TTY (tty)
    '';
    shellAliases = {
      ls = "eza";
      find = "fd";
    };
  };
}
