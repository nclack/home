{
  description = "Nathan's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
    mkNixos = hostname: nixpkgs.lib.nixosSystem
      {
        system = "aarch64-linux";
        specialArgs = {inherit inputs; inherit hostname;};
        modules = [
          ./${hostname}

          home-manager.nixosModules.home-manager 
          {
            home-manager = {
              extraSpecialArgs = {inherit inputs;};
              useGlobalPkgs = true;
              useUserPackages = true;
              users = {
                "nclack" = import ./lib/users/nclack/home.nix;
              };
            };
          }
        ];
      };  
  in
  {
    nixosConfigurations = {
      whorl = mkNixos "whorl";
    };
  };
}    
