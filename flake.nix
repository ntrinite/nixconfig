{
  description = "Flakey Boi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    # Do not override its nixpkgs input, otherwise there can be mismatch between patches and kernel version
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
      ...
    }@inputs:
    {

      nixosConfigurations = {
        lotad = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ({
              nixpkgs = {
                config = {
                  allowUnfree = true;
                  allowUnfreePredicate = true;
                };
                # Add overlays.nix file
                overlays = [
                  # Use nixpkgs from your environment, nixpkgs.config will apply.
                  # Has small chance of kernel modules not being compatible with kernel version.
                  nix-cachyos-kernel.overlays.default

                ];

              };
            })
            ./hosts/lotad
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
