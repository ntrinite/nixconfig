{ pkgs, config, ... }:

{
  
  homeMgr = {
    discord.enable = true;
  };

  imports = [
    ../../modules/home-manager
  ];

  home.username = "ntrinite";
  home.homeDirectory = "/home/ntrinite";

  home.stateVersion = "25.11";

  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  news.display = "silent";
}
