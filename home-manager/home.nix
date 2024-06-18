# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "beanie";
    homeDirectory = "/home/beanie";
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    history = {
    size = 10000;
    share = true;
    path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [];
      theme = "gentoo";
    };
  };

  home.packages = with pkgs; [
    firefox
    kate
    #cura
    #vscode
    qalculate-qt
    octave
    #logisim-evolution
    #minecraft - marked as broken, refusing to evaluate
    steam
    #blender
    #epson-escpr2
    printrun
    discord
    google-chrome
    thunderbird
    vlc
    onlyoffice-bin
    pdfarranger
    solaar
    polychromatic
    kitty
    waybar
    wofi
    networkmanagerapplet
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    pavucontrol
    dunst
    polkit-kde-agent
    nvidia-vaapi-driver
    ffmpeg
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"]; if programs don't work in systemd services, but do on the terminal
    extraConfig = ''
      monitor=eDP-1, 1920x1080@144, 0x0, 1.3

      $mainMod = ALT

      $terminal = kitty
      $fileManager = dolphin
      $menu = wofi --show drun

      border_size = 2
      gaps_in = 3
      gaps_out = 5

      layout = master

      resize_on_border = true

      rounding = 5

      first_launch_animation = true

      key_press_enables_dpms = true

      animate_manual_resizes = true
      animate_mouse_windowdragging = false

      vrr = 1

      bind = $mainMod, F, exec, firefox
      bind = $mainMod, RETURN, exec, $terminal
      bind = $mainMod, P, exec, $menu
      bind = $mainMod SHIFT, C, killactive

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Example special workspace (scratchpad)
      bind = $mainMod, `, togglespecialworkspace, magic
      bind = $mainMod SHIFT, `, movetoworkspace, special:magic

      bind = $mainMod SHIFT, right, resizeactive, 50 0
      bind = $mainMod SHIFT, left, resizeactive, -50 0
      bind = $mainMod SHIFT, up, resizeactive, 0 -50
      bind = $mainMod SHIFT, down, resizeactive, 0 50

      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = NVD_BACKEND,direct

      master {
          no_gaps_when_only = 1
      }

      gestures {
        workspace_swipe = true
      }

      input {
        touchpad {
          disable_while_typing = true
          natural_scroll = true
          clickfinger_behavior = true
          tap-and-drag = true;
        }
      }

      exec-once = dunst & waybar & hyprpaper & nm-applet

    '';
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    neovim.enable = true;
    hyprlock = {
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
            path = "~/.background.png";
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
  };

  services = {
    hypridle = {
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
    hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload =
          [ "/share/wallpapers/buttons.png" "/share/wallpapers/cat_pacman.png" ];

        wallpaper = [
          "eDP-1,/share/wallpapers/cat_pacman.png"
        ];
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
