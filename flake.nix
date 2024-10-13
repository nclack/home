{
  description = "Nathan's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils,... }@inputs: 
    let
      mkNixos = hostname: system: nixpkgs.lib.nixosSystem
        {
          inherit system;
          specialArgs = {inherit inputs; inherit hostname;};
          modules = [

            ./hosts/${hostname}

            ./users/nclack

          ];
        };  
    in
    {
      nixosConfigurations = {
        whorl = mkNixos "whorl" "aarch64-linux";
        oreb = mkNixos "oreb""x86_64-linux";
      };
    }

    //

    flake-utils.lib.eachDefaultSystem( system:
      let 
        pkgs = import nixpkgs { inherit system; };
      in 
      {
        devShell = import ./shell.nix {inherit pkgs;}; 
      }
    );
}    
