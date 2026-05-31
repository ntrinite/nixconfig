{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dex.cachy;
in
{
  options = {
    dex.cachy = {
      enable = lib.mkEnableOption "Enable cachyos kernel";
      variant = lib.mkOption {
        default = null;
        type = lib.types.nullOr (
          lib.types.enum [
            "lto"
            "lts"
            "server"
            "hardened"
          ]
        );
        description = ''
          This option determines the CachyOS kernel variant to use.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = lib.mkMerge [
      (lib.mkIf (cfg.variant == null) pkgs.cachyosKernels.linuxPackages-cachyos-latest)
      (lib.mkIf (cfg.variant == "lts") pkgs.cachyosKernels.linuxPackages-cachyos-latest-lts)
      (lib.mkIf (cfg.variant == "lto") pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto)
      (lib.mkIf (cfg.variant == "server") pkgs.cachyosKernels.linuxPackages-cachyos-latest-server)
      (lib.mkIf (cfg.variant == "hardened") pkgs.cachyosKernels.linuxPackages-cachyos-latest-hardened)
    ];
    # services.scx.enable = true;
    # services.scx.package = pkgs.scx.rustscheds;
    # services.scx.scheduler = "scx_lavd";
    boot.consoleLogLevel = 0;

    # Binary cache
    nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
    nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };
}
