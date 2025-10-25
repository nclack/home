{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    ./authorized-keys.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {inherit inputs;};
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        users = {
          "nclack" = import ./home.nix;
        };
      };
    }

    ./modules/steam.nix
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nclack = {
    isNormalUser = true;
    description = "Nathan Clack";
    # TODO: clean up these groups. Only needed on some hosts.
    extraGroups = ["networkmanager" "wheel" "input" "plugdev" "dialout" "uucp" "openrazer"];
    shell = pkgs.fish;
    packages = with pkgs; [
      git
      fish
      btop
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

  # this was some workaround for some gnome issue, iirc
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
}
