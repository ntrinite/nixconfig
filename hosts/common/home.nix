# Shared home-manager baseline applied to the user on every host ( via home-manager.sharedModules)
# in hosts/commmon/nixos.nix
#
{ ... }:
{
  programs.home-manager.enable = true;

  dex = {
    terminator.enable = true;
    vscode.enable = true;
    direnv.enable = true;
  };

  home = {
    sessionVariables = {
      EDITOR = "vim";
    };
    shellAliases = {
      cdgit = "cd ~/git";
      gs = "git status";
      l = "ls";
      la = "ls -a";
      ll = "ls -l";
      lla = "ls -la";
      submod = "git submodule update --init --recursive";
      cdnix = "cd ~/.nix-cfg";
      codenix = "code ~/.nix-cfg";
    };
  };

  news.display = "silent";
}
