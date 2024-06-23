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
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
  };

  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Fantasque Sans Mono Nerd Font";
      size = 14;
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
    yofi
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
    dolphin
    nerdfonts
    fantasque-sans-mono
    nixfmt-rfc-style
    blueman
    pass-wayland
    gnupg
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"]; #if programs don't work in systemd services, but do on the terminal

    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];

    settings = {
      "$mod" = "ALT";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "yofi";
      bind = [
        "$mod, Q, exec, pgrep qalculate-gtk && hyprctl dispatch togglespecialworkspace calculator || qalculate-gtk &"
        #"$mod, TAB, hyprexpo:expo, toggle # can be: toggle, off/disable or on/enable"
        "$mod, F, exec, firefox"
        "$mod, RETURN, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, P, exec, $menu"
        "$mod SHIFT, C, killactive"

        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod SHIFT, right, resizeactive, 50 0"
        "$mod SHIFT, left, resizeactive, -50 0"
        "$mod SHIFT, up, resizeactive, 0 -50"
        "$mod SHIFT, down, resizeactive, 0 50"

        # Example special workspace (scratchpad)
        "$mod, grave, togglespecialworkspace, magic"
        "$mod SHIFT, grave, movetoworkspace, special:magic"
      ]
      ++ (
          # workspaces
          #  $mod + [shift +] {1..10} to [move to] workspace {1..10}
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

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
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
        smart_split = "true";
        no_gaps_when_only = "1";
      };

      gestures = {
        workspace_swipe = "true";
      };

      input = {
        touchpad = {
          disable_while_typing = "true";
          natural_scroll = "true";
          clickfinger_behavior = "true";
          tap-and-drag = "true";
        };
      };
    };

    extraConfig = ''
      monitor=eDP-1, 1920x1080@144, 0x0, 1.333333

      #env = LIBVA_DRIVER_NAME,nvidia
      #env = XDG_SESSION_TYPE,wayland
      #env = GBM_BACKEND,nvidia-drm
      #env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      #env = NVD_BACKEND,direct

      exec-once = dbus-update-activation-environment --systemd --all
      exec-once = dunst & waybar & hyprpaper & nm-applet
    '';
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    neovim.enable = true;
    gpg.enable = true;
    zsh = {
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
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
      pinentryPackage = pkgs.pinentry-qt;
      enableScDaemon = false;
    };

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
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
