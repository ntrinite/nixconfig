# Per-host home-manager configuration
#
# Shared HM config (hosts/common/home.nix) and modules defined in modules/home/
# are already imported via sharedModules
# This allows us to define per host app configurations, toggles, etc.
{ ... }:

{
  # dex like pokedex
  dex = {
    discord.enable = true;
    terminator.enable = true;
  };

  home.username = "ntrinite";
  home.homeDirectory = "/home/ntrinite";
  home.stateVersion = "25.11";
}
