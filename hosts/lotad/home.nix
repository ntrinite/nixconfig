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
  };

  # xdg.terminal-exec = {
  #   enable = true;
  #   settings = {
  #     default = [
  #       "terminator.desktop"
  #     ];
  #   };
  # };

  home = {
    username = "ntrinite";
    homeDirectory = "/home/ntrinite";
    stateVersion = "25.11";
    sessionVariables = {
      TERMINAL = "terminator";
    };
  };
}
