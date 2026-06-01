{ config, pkgs, ... }:
{
  imports = [
    ./kde.nix
    ./cachyos.nix
    ./fish.nix
  ];
}
