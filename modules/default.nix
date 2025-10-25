{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./nix.nix
    ./locale.nix
    ./ssh.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
