{ pkgs, config, ...}:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label   = "lock";
        action  = "sleep 1; ${pkgs.swaylock}/bin/swaylock";
        text    = "Lock";
        keybind = "l";
      }
      {
        label   = "reboot";
        action  = "sleep 1; systemctl reboot";
        text    = "Reboot";
        keybind = "r"; 
      }
      {
        label   = "hibernate";
        action  = "sleep 1; systemctl hibernate";
        text    = "Hibernate";
        keybind = "h";
      }
      {
        label   = "logout";
        action  = "loginctl terminate-user $USER";
        text    = "Exit";
        keybind =  "e";
      }
      {
        label   = "shutdown";
        action  = "sleep 1; systemctl poweroff";
        text    = "Shutdown";
        keybind = "s";
      }
      {
        label   = "suspend";
        action  = "sleep 1; systemctl suspend";
        text    = "Suspend";
        keybind = "u";
      }
    ];
  };
}
