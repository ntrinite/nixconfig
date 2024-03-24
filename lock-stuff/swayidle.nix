{ pkgs, config, ... }: {
  services.swayidle =
    let
      lockCommand = "${pkgs.swaylock}/bin/swaylock -fF";
      
      # Turn on/off the monitor
      dpmsCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms";
    in
    {
      enable = true;
      systemdTarget = "hyprland-session.target";
      timeouts = [
        {
          timeout = 290;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds' -t 10";
        }
        {
          timeout = 300;
          command = "${lockCommand}";
        }
        {
          timeout = 600;
          command = "${dpmsCommand} off";
          resumeCommand = "${dpmsCommand} on";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${lockCommand}";
        }
        {
          event = "lock";
          command = "${lockCommand}";
        }
      ];
    };
}
