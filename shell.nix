{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "dev-home";

  packages = with pkgs; [
    alejandra
    nil
    nixd
  ];

  shellHook = ''
    exec fish
  '';
}
