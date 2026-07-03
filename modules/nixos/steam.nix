{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dex.steam;
  inherit (lib.options) mkEnableOption;
  inherit (lib) mkIf;
in
{
  # Will likely change this to just "gaming" or something
  options.dex.steam = {
    enable = mkEnableOption "enable steam and basic steam gaming";
  };
  config = mkIf cfg.enable {
    programs = {
      gamescope = {
        enable = true;
        capSysNice = false;
      };
      steam = {
        enable = true;
        localNetworkGameTransfers.openFirewall = true;
        dedicatedServer.openFirewall = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extraPackages = with pkgs; [
          kdePackages.breeze-icons
          kdePackages.breeze
          gamescope
          steam-devices-udev-rules
          dualsensectl
          lsfg-vk
          lsfg-vk-ui
        ];
      };

      appimage = {
        enable = true;
        binfmt = true;

      };
    };

    hardware.steam-hardware.enable = true;

    environment.systemPackages = with pkgs; [
      protonup-qt
      gamescope
      steam-devices-udev-rules
      dualsensectl
      lsfg-vk
      lsfg-vk-ui
    ];
  };
}
