{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dex.terminator;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib) mkIf;
  inherit (lib.types) package;

  after-dark = {
    name = "After Dark";
    background_color = "#10111b";
    cursor_color = "#aaaaaa";
    palette = "#2e3436:#ef4a9e:#00d2bc:#e7ca7a:#9399fa:#ca5bcc:#86d079:#d3d7cf:#555753:#ef4a9e:#00d2bc:#e7ca7a:#9399fa:#ca5bcc:#86d079:#eeeeec";
    type = "dark";
  };
in
{
  options.dex.terminator = {
    enable = mkEnableOption "Enable Terminator";
    package = mkOption {
      type = package;
      default = pkgs.terminator;
    };
  };

  config = mkIf cfg.enable {
    programs.terminator = {
      enable = true;
      package = cfg.package;
      config = {
        global_config = {
          tab_position = "top";
          case_sensitive = false;
        };
        profiles.default = {
          font = "Monospace Regular 12";
          use_system_font = false;
          scrollback_infinite = true;
          cursor_blink = true;
          show_titlebar = false;

          cursor_color = after-dark.cursor_color;
          background_color = after-dark.background_color;
          palette = after-dark.palette;
          background_image = "None";
          background_type = "transparent";
          background_darkness = 0.85;
        };
      };
    };
  };

}
