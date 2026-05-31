{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dex.discord;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib) mkIf;
  inherit (lib.types) nullOr package;
in
{
  options.dex.discord = {
    enable = mkEnableOption "Enable Discord";
    package = mkOption {
      type = nullOr package;
      default = pkgs.discord;
      description = ''
        Either pkgs.discord, pkgs.discord-ptb, or pkgs.discord-canary
        I could probably do something to guarantee this but eh
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.discord = {
      enable = true;
      package = cfg.package;
    };

  };
}
