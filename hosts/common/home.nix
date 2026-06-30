# Shared home-manager baseline applied to the user on every host ( via home-manager.sharedModules)
# in hosts/commmon/nixos.nix
#
{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  dex = {
    terminator.enable = true;
    vscode.enable = true;
    direnv.enable = true;
    vim.enable = true;
    pokefetch.enable = true;
  };

  home = {
    packages = with pkgs; [
      htop
      nil # nix language server
      nixfmt # nix formatter
      mcap-cli
      vlc
      tree
      ffmpeg
      curl
      jq
      spotify
    ];
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
