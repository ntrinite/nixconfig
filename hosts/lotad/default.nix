# Main PC - NixOS
{ ... }:
{
  imports = [
    ../common/nixos.nix # shared modules/configs + home-manager setup
    ./configuration.nix # pc specific system configs
    ./hardware-configuration.nix
  ];

  networking.hostName = "lotad";

  # Enable specifics from modules/nixos
  # dex like pokedex
  dex.cachy.enable = true; # use CahcyOS kernel
  dex.kde.enable = true; # KDE Plasma DE

  # Setting this here instead of home.nix because this will set my default shell as well
  dex.fish.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  home-manager.users.ntrinite = import ./home.nix;

}
