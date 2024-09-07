{pkgs,...}:{

	imports = [
		../users/nclack
		./modules/nix.nix
		./modules/locale.nix
		./modules/ssh.nix
	];

  nixpkgs.config.allowUnfree = true;
	
}
