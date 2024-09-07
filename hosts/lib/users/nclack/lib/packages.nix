{pkgs,...}: 
{
	home.packages = with pkgs; [
		bat
		delta
		fish
		fzf
		gh
		git
		ripgrep
	];
}
