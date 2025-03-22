# Windsurf IDE package definition
{
  lib,
  stdenv,
  nixpkgs,
  callPackage,
  fetchurl,
  nixosTests,
}: let
  version = "1.1.0"; # "windsurfVersion"
  hash = "c418a14b63f051e96dafb37fe06f1fe0b10ba3c8"; # "version"
in
  callPackage "${nixpkgs}/pkgs/applications/editors/vscode/generic.nix" rec {
    inherit version;
    commandLineArgs = "";
    useVSCodeRipgrep = stdenv.hostPlatform.isDarwin;

    pname = "windsurf";

    executableName = "windsurf";
    longName = "Windsurf";
    shortName = "windsurf";

    src = fetchurl {
      url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/${hash}/Windsurf-linux-x64-${version}.tar.gz";
      hash = "sha256-fsDPzHtAmQIfFX7dji598Q+KXO6A5F9IFEC+bnmQzVU=";
    };

    sourceRoot = "Windsurf";

    tests = nixosTests.vscodium;

    updateScript = "nil";

    meta = with lib; {
      description = "The first agentic IDE, and then some";
      platforms = platforms.linux;
    };
  }
