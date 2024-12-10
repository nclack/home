{
  description = "Nathan's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    ...
  } @ inputs: let
    mkNixos = hostname: system:
      nixpkgs.lib.nixosSystem
      {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit hostname;
        };
        modules = [
          ./hosts/${hostname}
          ./users/nclack
        ];
      };
    
    # Special function for the ISO build
    mkIso = hostname: system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit hostname;
        };
        modules = [
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
        pkgs = import nixpkgs {inherit system;};
      in {
        formatter = pkgs.alejandra;
        devShell = import ./shell.nix {inherit pkgs;};
      }
    );
}
