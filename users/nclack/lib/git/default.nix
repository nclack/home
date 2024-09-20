{
	programs.git = {
		enable = true;
		userName = "Nathan Clack";
		userEmail = "nclack@gmail.com";
		ignores = import ./ignores.nix;
		delta = {
			enable = true;
			options = {
				navigate = true;
			};
		};
		extraConfig = {
		  init.defaultBranch = "main";
			alias = {
				br       = "branch";
				co       = "checkout";
				ci       = "commit";
				st       = "status";
				ss       = "status -sb";
				log      = "log --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)";
				lola     = "log --all --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
				tags     = "tag -l";
				branches = "branch -a";
				remotes  = "remote -v";
			};
		};
	};
}
