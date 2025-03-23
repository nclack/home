{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules/nix.nix
    ./modules/locale.nix
    ./modules/ssh.nix
    ./modules/hyprland.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
