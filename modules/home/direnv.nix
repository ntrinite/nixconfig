{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dex.direnv;
  inherit (lib.options) mkEnableOption;
  inherit (lib) mkIf;
in
{
  options.dex.direnv = {
    enable = mkEnableOption "Enable Direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
