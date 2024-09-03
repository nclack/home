{
  description = "Nathan's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-cosmic, ... }@inputs: 
  let
    mkNixos = hostname: system: nixpkgs.lib.nixosSystem
      {
        inherit system;
        specialArgs = {inherit inputs; inherit hostname;};
        modules = [
          # nixos-cosmic
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default

          ./${hostname}

          {
            # pin system nixpkgs to the same version as the flake input
            nix.nixPath = ["nixpkgs=${nixpkgs}"];
          }

          home-manager.nixosModules.home-manager 
          {
            home-manager = {
              extraSpecialArgs = {inherit inputs;};
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
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
      whorl = mkNixos "whorl" "aarch64-linux";
      oreb = mkNixos "oreb" "x86_64-linux";
    };
  };
}    
