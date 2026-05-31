# laptop - NixOS
#
# SKELETON: Laptop is not setup yet but having basic stuff defined
# to make the setup easier
{ ... }:
{
  imports = [
    ../common/nixos.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "poliwrath";

  # Might as well start off with KDE
  dex.kde.enable = true;

  # system.stateVersion

  home-manager.users.ntrinite = import ./home.nix;

}
