{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dex.flameshot;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) mkIf;
  inherit (lib.types) str;
in
{
  options.dex.flameshot = {
    enable = mkEnableOption "Enable flameshot";
    savePath = mkOption {
      type = str;
      description = "Screenshot save path";
    };
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          showStartupLaunchMessage = false;
          savePath = cfg.savePath;
          contrastOpacity = 188;
          contrastUiColor = "#54782a";
          drawColor = "#ff0303ff";
          drawThickness = 4;
          startupLaunch = "true";
          uiColor = "#00611bff";
        };
      };
    };
  };
}
