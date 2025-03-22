# This file defines an overlay that makes all custom packages available
{
  pkgs,
  nixpkgs,
}: let
  # Import all package definitions
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = {
    # cursor = callPackage ./cursor.nix {}; # FIXME: can't download AppImage due to some SSL error
    windsurf = callPackage ./windsurf.nix {inherit nixpkgs;};
  };
in
  self
