{pkgs,...}:{

	imports = [
		../users/nclack
		./modules/nix.nix
		./modules/locale.nix
	];

  nixpkgs.config.allowUnfree = true;
	
}
