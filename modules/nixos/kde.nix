{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dex.kde;
  inherit (lib.options) mkEnableOption;
  inherit (lib) mkIf;
in
{
  options.dex.kde = {
    enable = mkEnableOption "Enable KDE Plasma Desktop Environment";

  };

  config = mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
