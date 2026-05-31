# Shared home-manager baseline applied to the user on every host ( via home-manager.sharedModules)
# in hosts/commmon/nixos.nix
#
{ ... }:
{
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };

  news.display = "silent";
}
