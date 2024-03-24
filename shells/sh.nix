{ config, pkgs, ...}:

let
aliases = {
  gs = "git status";
  la = "ls -a";
  ll = "ls -l";
  lla = "ls -la";
  hmsf = "home-manager switch --flake ~/myflakes/#ntrinite";
  hm-gens = "home-manager generations";
  rebuild-flakes = "sudo nixos-rebuild switch --flake ~/myflakes/#nixos";
  flakes = "cd ~/myflakes";
  vimhome = "vim ~/myflakes/home.nix";
  vimconfig = "sudo vim ~/myflakes/nixos/configuration.nix";
  cdcfg="cd ~/.config/";
}; 

in
{

programs = {
  fish = { 
    enable = true;
    shellAliases = aliases;
  };
 
  bash = { 
    enable = true;
    shellAliases = aliases // {
      sourcebash = "source ~/.bashrc";
    };
  };
};

}

