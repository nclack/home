{config, pkgs, lib, ...}: 
{
	home.packages = with pkgs; [
		bat
		delta
		fish
		fzf
		gh
		git
		ripgrep
		tree
	] ++ lib.optionals config.xsession.enable [
		xclip
		xsel
	];
}
