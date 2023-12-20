{pkgs,...}: {
	imports = [
		./authorized-keys.nix
	];

	programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nclack = {
    isNormalUser = true;
    description = "Nathan Clack";
    extraGroups = [ "networkmanager" "wheel" ];
		shell = pkgs.fish;
    packages = with pkgs; [
      git
    ];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "nclack";
}
