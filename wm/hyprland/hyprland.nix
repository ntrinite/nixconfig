{pkgs, lib, config, ...}:

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
  ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
  ${pkgs.waybar}/bin/waybar &
  ${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit
  '';

  lockScript = pkgs.pkgs.writeShellScriptBin "lock" ''
    ${pkgs.swaylock}/bin/swaylock -f
  '';

  mod = "SUPER";
in
  {
    wayland.windowManager.hyprland = {
      #allows home-manager to configure hyprland
      enable = true; 
      xwayland.enable = true;
      enableNvidiaPatches = true;
      settings = {
       "$mod" = mod;
        env = [
          "NIXOS_OZONE_WL,1"
          "WLR_NO_HARDWARE_CURSORS,1"
        ];
        #decoration = {
        #  rounding = 10;
        #  blur = {
        #    enabled = true;
        #    size = 3;
        #    passes = 1;
        #  };
        #  drop_shadow = true;
        #  shadow_range = "4";
        #  shadow_render_power = "3";
        #  "col.shadow" = "rgba(1a1a1aee)";
        #};
        #animation = {
        #  enabled = true;
        #  bezier = "myBezier, 0.05, 0.9, 0.1, 1.05"
        #  "animation = "
        #};
        bindm = [
          "$mod, mouse:272, movewindow"
	  "$mod, mouse:273, resizewindow"
        ];
        bind = [
          "$mod, W, exec, kitty"
          "$mod, C, killactive"
          "$mod, M, exit"
          "$mod, R, exec, ${pkgs.rofi}/bin/rofi -show drun -show-icons"
          "$mod, E, exec, dolphin"
          "$mod, V, togglefloating"
          # "$mod R, exec, ${pkgs.wofi}/wofi --show drun"
          "$mod, P, pseudo" # dwindle
          "$mod, J, togglesplit" # dwindle
          
	  # move focus 
	  "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"
          
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          "$mod CTRL, left, swapwindow, l"
          "$mod CTRL, right, swapwindow, r"
          "$mod CTRL, up, swapwindow, u"
          "$mod CTRL, down, swapwindow, d"

          # Lock/Idle stuff
          "$mod CTRL, Q, exec, ${pkgs.wlogout}/bin/wlogout"
          "$mod, L, exec, ${lockScript}/bin/lock"
        ]
        ++ (
          # add workspaces to bind list (taken from the hyprland.org wiki
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
        exec-once = ''${startupScript}/bin/start'';
        #exec-once = ''
   	
        #'';
      };
      extraConfig = builtins.readFile ./hyprland.conf;
    };
  }




