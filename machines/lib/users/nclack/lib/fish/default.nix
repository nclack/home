{pkgs,...}: {
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      { name = "grc"; src = grc; }
      { name = "z"; src = z; }
      { name = "fzf-fish"; src = fzf-fish; }
      { name = "tide"; src = tide; }
    ];
    interactiveShellInit = ''
      set --export GIT_EDITOR hx
    '';
  };
}
