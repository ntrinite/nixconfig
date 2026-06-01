{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dex.fish;
  inherit (lib.options) mkEnableOption;
  inherit (lib) mkIf;
in
{
  options.dex.fish = {
    enable = mkEnableOption "enable fish shell";
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;
    users.users.ntrinite.shell = pkgs.fish;

    # technically there are 2 dex.fish.enable but this is
    # to kind of have one option that lets us set things at a system level (default shell)
    # and keep things at a home-manager level
    home-manager.users.ntrinite.dex.fish.enable = true;
  };

}
