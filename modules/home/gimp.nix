{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dex.gimp;
  inherit (lib.options) mkEnableOption;
  inherit (lib) mkIf;
in
{
  options.dex.gimp = {
    enable = mkEnableOption "Enable Gimp";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
    ];
  };
}
