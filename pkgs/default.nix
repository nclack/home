# This file defines an overlay that makes all custom packages available
{
  pkgs,
  nixpkgs,
}: let
  # Import all package definitions
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = {
    # Add your custom packages here
    example = callPackage ./example {};
    windsurf = callPackage ./windsurf.nix {inherit nixpkgs;};
  };
in
  self
