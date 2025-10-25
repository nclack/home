{
  description = "Nathan's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    # Common nixpkgs configuration
    nixpkgsConfig = {
      config = {
        allowUnfree = true;
      };
      overlays = [];
    };

    mkNixos = hostname: system:
      nixpkgs.lib.nixosSystem
      {
        inherit system;
        specialArgs = {
          inherit inputs hostname;
        };
        modules = [
          {
            nixpkgs = nixpkgsConfig;
          }
          ./hosts/${hostname}
          ./users/nclack
        ];
      };

    # Special function for the ISO build
    mkIso = hostname: system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs hostname;
        };
        modules = [
          {
            nixpkgs = nixpkgsConfig;
          }
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./hosts/${hostname}/iso.nix
        ];
      };
  in
    {
      nixosConfigurations = {
        whorl = mkNixos "whorl" "aarch64-linux";
        oreb = mkNixos "oreb" "x86_64-linux";
        gyoll = mkNixos "gyoll" "x86_64-linux";

        whorl-iso = mkIso "whorl" "aarch64-linux";
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs (nixpkgsConfig // {inherit system;});
      in {
        formatter = pkgs.alejandra;
        devShell = import ./shell.nix {inherit pkgs;};
      }
    );
}
