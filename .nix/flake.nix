# flake.nix
{

  description = "My first flake!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, chaotic, catppuccin, spicetify-nix, nix-gaming, ...}@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      spicepkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
      nix-gaming = inputs.nix-gaming.packages.${pkgs.system};
    in {
    # NixOS Setup
    nixosConfigurations.NixCanvas = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit nix-gaming;
      };
      modules = [
        ./configuration.nix
	      catppuccin.nixosModules.catppuccin
        chaotic.nixosModules.default
        spicetify-nix.nixosModules.spicetify
	# ...
      ];
    };
    # Home-Manager Setup
    homeConfigurations.canvas = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit spicepkgs;
      };
      modules = [
        ./home.nix
	      catppuccin.homeModules.catppuccin
        chaotic.homeManagerModules.default
        spicetify-nix.homeManagerModules.spicetify
        # ...
      ];
    };
  };

}
