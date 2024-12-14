{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  home = {
    username = "beanie";
    homeDirectory = "/home/beanie";
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      EDITOR = lib.mkForce "lvim";
    };
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Catppuccin-Mocha-Mauve";
      size = 20;
    };
  };

  catppuccin = {
      enable = true;
      flavor = "mocha";
  };

  xdg = {
    enable = false;
    mime.enable = true;
    mimeApps.enable = true;
    portal = {
      enable = true;
      configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };
  };

  gtk = {
    enable = true;
    #catppuccin = {
    #  enable = true;
    #  size = "compact";
    #  flavor = "mocha";
    #  icon.enable = true;
    #};

    font = {
      name = "Fantasque Sans Mono Nerd Font";
      size = 10;
    };
  };

  qt = {
    style.catppuccin.enable = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home.packages =
  (with pkgs; [
    #firefox
    kate
    #cura
    #vscode
    qalculate-qt
    octaveFull
    octavePackages.symbolic
    #logisim-evolution
    #minecraft - marked as broken, refusing to evaluate
    steam
    #blender
    #epson-escpr2
    printrun
    discord
    google-chrome
    #thunderbird
    #vlc
    #onlyoffice-bin
    pdfarranger
    solaar
    #polychromatic
    kitty
    waybar
    nwg-bar
    nwg-look
    nwg-panel
    nwg-menu
    nwg-hello
    nwg-displays
    glib
    ark
    yofi
    #helix
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
    #nvidia-vaapi-driver
    ffmpeg
    #nerdfonts
    fantasque-sans-mono
    nixfmt-rfc-style
    #blueman
    pass-wayland
    gnupg
    passff-host
    xfce.thunar
    walk
    lunarvim
    pyprland
    onedrive
    onedrivegui
    #virt-manager
    #freerdp
    appimage-run
    #apfs-fuse
    nix-tree
  ])
  ++ (with pkgs-unstable; [
    zed-editor
  ]);


  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"]; #if programs don't work in systemd services, but do on the terminal
    #catppuccin.enable = true;
    settings = {
      #monitor = "eDP-1, 1920x1080@144, 0x0, 1.333333";
      "$mod" = "ALT";
      "$terminal" = "kitty";
      "$fileManager" = "nemo";
      "$menu" = "yofi";
      "$lockcmd" = "";
      bind = [
        "$mod, Q, exec, pgrep qalculate-gtk && hyprctl dispatch togglespecialworkspace calculator || qalculate-gtk &"
        "$mod, TAB, hyprexpo:expo, toggle # can be: toggle, off/disable or on/enalbe"
        "$mod, F, exec, firefox"
        "$mod SHIFT, RETURN, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, P, exec, $menu"
        "$mod SHIFT, C, killactive"
        "$mod SHIFT, CTRL, l, exec, $lockcmd"

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

        "$mod SHIFT, Q, exit"
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
        #smart_split = "true";
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
      #env = LIBVA_DRIVER_NAME,nvidia
      #env = XDG_SESSION_TYPE,wayland
      #env = GBM_BACKEND,nvidia-drm
      #env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      #env = NVD_BACKEND,direct
      env = HYPRCURSOR_THEME,MyCursor
      env = HYPRCURSOR_SIZE,20
      env = XCURSOR_THEME,MyCursor
      env = XCURSOR_SIZE,20

      exec-once = dbus-update-activation-environment --systemd --all
      exec-once = dunst & waybar & hyprpaper & nm-applet
    '';
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userEmail = "29309688+beeaniebee@users.noreply.github.com";
      userName = "beeaniebee";
    };
    gpg.enable = true;

    kitty = {
      enable = true;
      #catppuccin.enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;

      initExtra = ''
        function lk {
          cd "$(walk --icons "$@")"
        }
      '';

      shellAliases = {
        stdp = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p steam-run --run 'steam-run ~/Documents/Mods/Stardrop/Internal $@'";
      };

      sessionVariables = {
        EDITOR = "$(which lvim)";
      };
      syntaxHighlighting = {
        enable = true;
        #catppuccin.enable = true;
      };
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
  };

  services = {
    blueman-applet.enable = true;
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
      pinentryPackage = pkgs.pinentry-qt;
      enableScDaemon = false;
    };

    dunst = {
      enable = true;
      #catppuccin.enable = true;
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
        preload = "~/.wallpaper.png";
        wallpaper = "eDP-1,~/.wallpaper.png";
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
