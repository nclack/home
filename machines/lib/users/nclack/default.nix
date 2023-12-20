{pkgs,...}: {
	imports = [
		./authorized-keys.nix
	];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nclack = {
    isNormalUser = true;
    description = "Nathan Clack";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      git
    ];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "nclack";
}
