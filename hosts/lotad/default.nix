{
  config,
  pkgs,
  inputs,
  ...
}:
{
  systemSettings = {
    kde.enable = true;
    cachy = {
      enable = true;
    };
  };

  imports = [
    ./configuration.nix
    ../../modules/nixos
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "ntrinite" = import ./home.nix;
    };
    useGlobalPkgs = true;
  };


}
