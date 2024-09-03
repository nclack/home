{pkgs,...}: {
	imports = [
		./authorized-keys.nix
	];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nclack = {
    isNormalUser = true;
    description = "Nathan Clack";
    extraGroups = [ "networkmanager" "wheel" ];
		shell = pkgs.fish;
    packages = with pkgs; [
      git
			fish
    ];
  };

  # Enable automatic login for the user.
  services = {
		getty.autologinUser = "nclack";

		displayManager.autoLogin = {
			enable = true;
			user = "nclack";
		};
	};

	systemd.services = {
		"getty@tty1".enable = false;
		"autovt@tty1".enable = false;
	};
}
