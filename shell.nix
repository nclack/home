{
  pkgs ? import <nixpkgs> {},
  codex ? pkgs.codex,
}:
pkgs.mkShell {
  name = "dev-home";

  packages = [
    pkgs.alejandra
    codex
    pkgs.nil
    pkgs.nixd
  ];
}
