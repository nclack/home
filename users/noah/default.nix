{pkgs, ...}: {
  home-manager.users.noah = import ./home.nix;

  # Set the password locally with `sudo passwd noah`.
  users.users.noah = {
    isNormalUser = true;
    description = "Noah Clack";
    extraGroups = [
      "networkmanager"
      "input"
      "plugdev"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      git
      fish
      btop
    ];
  };
}
