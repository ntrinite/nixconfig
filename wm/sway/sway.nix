# TODO: actually set this up
'''{ config, pkgs, ...}:

let
mod_key = "Mod4";

in {
wayland.windowManager.sway = {
  enable = true;
  config = rec {
    modifier = mod_key;
    terminal = "kitty";
    startup = [
      # Launch firefox on start
      #{command = "firefox";}
    ];
  }; 
};
} 
'''
