{
  description = "Nathan's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
