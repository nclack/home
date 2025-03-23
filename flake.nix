{
  description = "Nathan's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    nixos-cosmic,
    hyprland,
    ...
  } @ inputs: let
    # Function to create an overlay for custom packages
    overlay = final: prev:
      import ./pkgs {
        pkgs = final;
        inherit nixpkgs;
      };

    # Common nixpkgs configuration
    nixpkgsConfig = {
      config = {
        allowUnfree = true;
      };
      overlays = [
        overlay
        nixos-cosmic.overlays.default
        hyprland.overlays.default
      ];
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

      overlays.default = overlay;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs (nixpkgsConfig // {inherit system;});
      in {
        formatter = pkgs.alejandra;
        devShell = import ./shell.nix {inherit pkgs;};
        packages = import ./pkgs {inherit pkgs nixpkgs;};
      }
    );
}
