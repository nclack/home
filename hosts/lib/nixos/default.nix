{pkgs,...}:{

	imports = [
		./modules/nix.nix
		./modules/locale.nix
		./modules/ssh.nix
	];

  nixpkgs.config.allowUnfree = true;
	
}
