{ config, pkgs, ... }:
{
  imports = [
    ./kde.nix
    ./cosmic.nix
    ./cachyos.nix
    ./fish.nix
    ./steam.nix
  ];
}
