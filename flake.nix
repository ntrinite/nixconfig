{
  description = "NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";   
 
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland, Learn to make a little more modular
    hyprland.url = "github:hyprwm/Hyprland";

    # NOTE: breaks hyprland if you try to follow nixpkgs
    #hyprland.inputs.nixpkgs.follows = "nixpkgs"; 
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
  let
    system = "x86_64-linux"; 
 
    #can be used if we don't want to specify nixpkgs.lib everywhere in `in`
    #lib = nixpkgs.lib;

    pkgs = import nixpkgs {
      inherit system; # copies the system variable defined in the outer scope
      # could also do system = system

      config = {
        # allows for programs/software that may have a payment option associated
        allowUnfree = true;    
      };
    };
  
  in {
    # Allows us to store different configurations in the same flake and rebuild based on the configuration
    nixosConfigurations = {
      # hostname, Refernces the configuration.nix
      # This configuration will look in there as well and use the info in there to configure nix
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/configuration.nix
        ]; 
      };
    };
    homeConfigurations = {
      ntrinite = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; # copies the pkgs = ... defined in the let
        modules = [./home.nix];
      };

    };
  
  };
}
