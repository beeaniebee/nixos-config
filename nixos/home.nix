{ inputs, lib, config, pkgs, ... }: {
  imports = [
  ];

  nixpkgs = {
    overlays = [
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

  home.packages = with pkgs; [
    firefox
    kate
    #cura
    #vscode
    qalculate-qt
    #octave
    #logisim-evolution
    #minecraft - marked as broken, refusing to evaluate
    steam
    #blender
    #epson-escpr2
    printrun
    #discord
    #google-chrome
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
    #systemd.variables = ["--all"]; if programs don't work in systemd services, but do on the terminal
    extraConfig = ''
      $mainMod = ALT

      $terminal = kitty
      $fileManager = dolphin
      $menu = wofi --show drun

      bind = $mainMod, F, exec, firefox
      bind = $mainMod, RETURN, exec, $terminal
      bind = $mainMod, P, exec, $menu

      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = NVD_BACKEND,direct

      gestures {
        workspace_swipe = false
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
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
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
          "DP-3,/share/wallpapers/buttons.png"
          "DP-1,/share/wallpapers/cat_pacman.png"
        ];
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
