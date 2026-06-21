{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dex.vim;
  inherit (lib.options) mkEnableOption;
  inherit (lib) mkIf;
in
{
  options.dex.vim = {
    enable = mkEnableOption "Enable Vim";
  };

  config = mkIf cfg.enable {
    programs.vim = {
      enable = true;
      settings = {
        number = true;
      };
    };
  };
}
