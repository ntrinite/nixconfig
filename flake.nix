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

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
      nix-vscode-extensions,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" ];
      forAllSystems = f: lib.genAttrs systems f;

      # nixpkgs settings shared across hosts
      pkgsModule = {
        nixpkgs = {
          config.allowUnfree = true;
          overlays = [ self.overlays.default ];
        };
      };
    in
    {
      # Allows other repos to consure this flake as an input and use the modules/dex options
      # defined in this repo
      overlays.default = import ./overlays { inherit inputs; };
      nixosModules.default = import ./modules/nixos;
      homeManagerModules.default = import ./modules/home;

      # NixOS hosts/configs
      nixosConfigurations = {

        # Main PC
        # sudo nixos-rebuild switch --flake .#lotad
        lotad = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            pkgsModule
            ./hosts/lotad
          ];
        };

        # Laptop
        # sudo nixos-rebuild switch --flake .#politoed
        politoed = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            pkgsModule
            ./hosts/politoed
          ];
        };
      };

      # legacyPackages: a nixpkgs instance per system with our overlay + allowUnfree already applied.
      # `nix build .#<pkgs>` / `nix shell` and downstream repos can use it
      # Not consumed by host configs above
      legacyPackages = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
          config.allowUnfree = true;
        }
      );

      # `nix fmt` formats the whole tree with nixfmt
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

    };
}
