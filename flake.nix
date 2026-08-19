{
  description = "Nathan's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex-cli = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    claude-code,
    codex-cli,
    ...
  } @ inputs: let
    # Common nixpkgs configuration
    nixpkgsConfig = {
      config = {
        allowUnfree = true;
      };
      overlays = [claude-code.overlays.default];
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
  in
    {
      nixosConfigurations = {
        whorl = mkNixos "whorl" "aarch64-linux";
        oreb = mkNixos "oreb" "x86_64-linux";
        gyoll = mkNixos "gyoll" "x86_64-linux";
        auk = mkNixos "auk" "x86_64-linux";
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs (nixpkgsConfig // {inherit system;});
      in {
        formatter = pkgs.alejandra;
        devShells = {
          default = import ./shell.nix {
            inherit pkgs;
            codex = codex-cli.packages.${system}.default;
          };
        };
      }
    );
}
