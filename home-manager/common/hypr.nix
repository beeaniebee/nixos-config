{ config, lib, ... }:
let
  cfg = config.my.hypr;
in
{
  options.my.hypr.enable = lib.mkEnableOption "Hyprland desktop environment";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.variables = [ "--all" ];

      settings = {
        "$mod" = "ALT";
        "$terminal" = "kitty";
        "$fileManager" = "nemo";
        "$menu" = "yofi";
        "$lockcmd" = "swaylock -f";
        bind = [
          "$mod, P, exec, $menu"
          "$mod, N, exec, dunstctl close"
          "$mod SHIFT, N, exec, dunstctl close-all"
          "$mod SHIFT, PERIOD, exec, dunstctl context"
          "$mod SHIFT, RETURN, exec, $terminal"
          "$mod, F, exec, firefox"
          "$mod, Q, exec, pgrep qalculate-gtk && hyprctl dispatch togglespecialworkspace calculator || qalculate-gtk &"
          "$mod, O, exec, obsidian"
          "$mod, grave, togglespecialworkspace, magic"
          "$mod SHIFT, grave, movetoworkspace, special:magic"
          ", XF86MonBrightnessUp, exec, light -A 5"
          ", XF86MonBrightnessDown, exec, light -U 5"
          ", XF86AudioLowerVolume, exec, pamixer -d 5"
          ", XF86AudioRaiseVolume, exec, pamixer -i 5"
          ", XF86AudioMute, exec, pamixer -t"
          "$mod SHIFT, CTRL L, exec, $lockcmd"
          "$mod, B, togglefloating"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod SHIFT, right, resizeactive, 50 0"
          "$mod SHIFT, left, resizeactive, -50 0"
          "$mod SHIFT, up, resizeactive, 0 -50"
          "$mod SHIFT, down, resizeactive, 0 50"
          "$mod, RETURN, swapactiveworkspaces"
          "$mod, TAB, hyprexpo:expo, toggle"
          "$mod+SHIFT, C, killactive"
          "$mod, F, fullscreen, 1"
          "$mod+SHIFT, F, fullscreen, 1"
          "$mod, SPACE, togglesplit"
          "$mod+SHIFT, SPACE, togglefloating"
          "$mod, 0, workspace, all"
          "$mod+SHIFT, 0, movetoworkspace, all"
          "$mod, COMMA, focusmonitor, -1"
          "$mod, PERIOD, focusmonitor, +1"
          "$mod+SHIFT, COMMA, movewindow, -1"
          "$mod+SHIFT, PERIOD, movewindow, +1"
          "$mod, MINUS, exec, hyprctl --batch 'setgaps -5'"
          "$mod, EQUAL, exec, hyprctl --batch 'setgaps +5'"
          "$mod+SHIFT, EQUAL, exec, hyprctl --batch 'setgaps 0'"
          "$mod+SHIFT, Q, exit"
          "$mod+CTRL+SHIFT, Q, exec, killall -9 Hyprland"
        ]
        ++ (
            builtins.concatLists (builtins.genList (
                x: let
                  ws = let
                    c = (x + 1) / 10;
                  in
                    toString (x + 1 - (c * 10));
                in [
                  "$mod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              )
              10)
        );

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod, mouse:274, togglefloating"
        ];

        general = {
          border_size = "2";
          gaps_in = "3";
          gaps_out = "5";
          layout = "dwindle";
          resize_on_border = "true";
        };

        decoration = {
          rounding = "5";
        };

        misc = {
          key_press_enables_dpms = "true";
          animate_manual_resizes = "true";
          animate_mouse_windowdragging = "true";
          vrr = "1";
        };

        xwayland = {
          force_zero_scaling = "true";
        };

        dwindle = {
          force_split = "2";
        };

        gestures = {
          workspace_swipe = "true";
        };

        input = {
          touchpad = {
            disable_while_typing = "false";
            natural_scroll = "true";
            clickfinger_behavior = "true";
            tap-and-drag = "true";
          };
        };
      };

      extraConfig = ''
        env = HYPRCURSOR_THEME,MyCursor
        env = HYPRCURSOR_SIZE,20
        env = XCURSOR_THEME,MyCursor
        env = XCURSOR_SIZE,20

        exec-once = dbus-update-activation-environment --systemd --all
        exec-once = dunst & waybar & hyprpaper & nm-applet
      '';
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = "~/.wallpaper.png";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = "Enter Password...";
            shadow_passes = 2;
          }
        ];
      };
    };

    services.dunst = {
      enable = true;
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 30;
            on-timeout = "hyprlock";
          }
          {
            timeout = 60;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        preload = "~/.wallpaper.png";
        wallpaper = "eDP-1,~/.wallpaper.png";
      };
    };
  };
}
