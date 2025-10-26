{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
    };
  };
  programs.git = {
    enable = true;
    ignores = import ./ignores.nix;
    signing = {
      key = "C42E5CBEA20D10A3";
      signByDefault = true;
    };
    settings = {
      user.name = "Nathan Clack";
      user.email = "nclack@gmail.com";
      init.defaultBranch = "main";
      tag.gpgsign = true;
      alias = {
        br = "branch";
        co = "checkout";
        ci = "commit";
        st = "status";
        ss = "status -sb";
        log = "log --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)";
        lola = "log --all --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        tags = "tag -l";
        branches = "branch -a";
        remotes = "remote -v";
      };
    };
  };
}
