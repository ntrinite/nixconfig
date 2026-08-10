{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dex.cosmic;
  inherit (lib.options) mkEnableOption;
  inherit (lib) mkIf;
in
{
  options.dex.cosmic = {
    enable = mkEnableOption "Enable Cosmic Desktop Environment";

  };

  config = mkIf cfg.enable {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
  };
}
