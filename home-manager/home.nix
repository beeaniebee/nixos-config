{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
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
      #EDITOR = lib.mkForce "lvim";
    };
  };

  xdg = {
    enable = false;
    mime.enable = true;
    mimeApps.enable = false;
    #portal = {
    #  enable = true;
    #  configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
    #  extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    #};
  };

  gtk = {
    enable = true;
    font = {
      name = "Fantasque Sans Mono Nerd Font";
    };
  };

  home.packages = with pkgs; [
    #firefox
    kdePackages.kate
    #cura
    #vscode
    qalculate-qt
    #octaveFull
    #octavePackages.symbolic
    #logisim-evolution
    #minecraft - marked as broken, refusing to evaluate
    #**steam
    #blender
    #epson-escpr2
    #printrun
    discord
    #google-chrome
    #thunderbird
    #onlyoffice-bin
    pdfarranger
    solaar
    #polychromatic
    #kitty
    #waybar
    #nwg-bar
    #nwg-look
    #nwg-panel
    #nwg-menu
    #nwg-hello
    #nwg-displays
    glib
    #ark
    #yofi
    #helix
    networkmanagerapplet
    #xdg-desktop-portal-gtk
    #xdg-desktop-portal-hyprland
    #meson
    #wayland-protocols
    #wayland-utils
    #wl-clipboard
    #wlroots
    #pavucontrol
    #dunst
    #polkit-kde-agent
    #nvidia-vaapi-driver
    #ffmpeg
    #nerdfonts
    fantasque-sans-mono
    nixfmt # ** -rfc-style
    #blueman
    pass-wayland
    gnupg
    passff-host
    #xfce.thunar
    walk
    #lunarvim
    #pyprland
    onedrive
    onedrivegui
    #virt-manager
    #freerdp
    appimage-run
    #apfs-fuse
    #nix-tree
    #obs-studio
    #obs-studio-plugins.droidcam-obs
    zed-editor
    libreoffice
    onlyoffice-desktopeditors
    #lutris
    #wine
    cosmic-store
    code-cursor
    opencode
    nil
    nixd
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
  ];

  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  systemd.variables = ["--all"]; #if programs don't work in systemd services, but do on the terminal
  #  #catppuccin.enable = true;
  #  settings = {
  #    #monitor = "eDP-1, 1920x1080@144, 0x0, 1.333333";
  #    "$mod" = "ALT";
  #    "$terminal" = "kitty";
  #    "$fileManager" = "nemo";
  #    "$menu" = "yofi";
  #    "$lockcmd" = "swaylock -f";
  #    bind = [
  #      # Application Launchers
  #      "$mod, P, exec, $menu"                        # Launch dmenu
  #      "$mod, N, exec, dunstctl close"                   # Close last dunst notification
  #      "$mod SHIFT, N, exec, dunstctl close-all"         # Close all dunst notifications
  #      "$mod SHIFT, PERIOD, exec, dunstctl context"      # Show dunst context menu
  #      "$mod SHIFT, RETURN, exec, $terminal"             # Launch terminal
  #      #"$mod, E, exec, $fileManager"
  #      "$mod, F, exec, firefox"
  #      "$mod, Q, exec, pgrep qalculate-gtk && hyprctl dispatch togglespecialworkspace calculator || qalculate-gtk &"
  #      "$mod, O, exec, obsidian"                         # Launch Obsidian

  #      # Example special workspace (scratchpad)
  #      "$mod, grave, togglespecialworkspace, magic"
  #      "$mod SHIFT, grave, movetoworkspace, special:magic"

  #      # Brightness & Volume (assumes light & pamixer or custom scripts)
  #      ", XF86MonBrightnessUp, exec, light -A 5"         # Increase brightness
  #      ", XF86MonBrightnessDown, exec, light -U 5"       # Decrease brightness
  #      ", XF86AudioLowerVolume, exec, pamixer -d 5"      # Decrease volume
  #      ", XF86AudioRaiseVolume, exec, pamixer -i 5"      # Increase volume
  #      ", XF86AudioMute, exec, pamixer -t"               # Toggle mute

  #      # Lock Screen
  #      "$mod SHIFT, CTRL L, exec, $lockcmd"           # Lock screen

  #      # Window Management
  #      "$mod, B, togglefloating"                         # Toggle floating (alt for togglebar)

  #      # Move focus with mainMod + arrow keys
  #      "$mod, left, movefocus, l"
  #      "$mod, right, movefocus, r"
  #      "$mod, up, movefocus, u"
  #      "$mod, down, movefocus, d"

  #      "$mod SHIFT, right, resizeactive, 50 0"
  #      "$mod SHIFT, left, resizeactive, -50 0"
  #      "$mod SHIFT, up, resizeactive, 0 -50"
  #      "$mod SHIFT, down, resizeactive, 0 50"

  #      "$mod, RETURN, swapactiveworkspaces"              # Similar to zoom/master behavior
  #      "$mod, TAB, hyprexpo:expo, toggle # can be: toggle, off/disable or on/enalbe"
  #      "$mod+SHIFT, C, killactive"                       # Close focused window

  #      # Layout switching (Hyprland uses workspaces & rules, not layouts)
  #      #"$mod, T, exec, set-layout tiling"                # Pseudo-command for example
  #      "$mod, F, fullscreen, 1"                          # Fullscreen current window
  #      "$mod+SHIFT, F, fullscreen, 1"                    # Alternate fullscreen
  #      #"$mod, M, exec, set-layout monocle"               # Custom layout handler
  #      #"$mod+SHIFT, M, exec, set-layout monocle-alt"     # Alternate monocle

  #      "$mod, SPACE, togglesplit"                        # Toggle layout split
  #      "$mod+SHIFT, SPACE, togglefloating"               # Toggle floating mode

  #      "$mod, 0, workspace, all"                         # View all workspaces (pseudo)
  #      "$mod+SHIFT, 0, movetoworkspace, all"             # Move window to all workspaces

  #      "$mod, COMMA, focusmonitor, -1"                   # Focus previous monitor
  #      "$mod, PERIOD, focusmonitor, +1"                  # Focus next monitor
  #      "$mod+SHIFT, COMMA, movewindow, -1"               # Move window to previous monitor
  #      "$mod+SHIFT, PERIOD, movewindow, +1"              # Move window to next monitor

  #      "$mod, MINUS, exec, hyprctl --batch 'setgaps -5'" # Decrease gaps
  #      "$mod, EQUAL, exec, hyprctl --batch 'setgaps +5'" # Increase gaps
  #      "$mod+SHIFT, EQUAL, exec, hyprctl --batch 'setgaps 0'" # Reset gaps

  #      "$mod+SHIFT, Q, exit"                             # Quit Hyprland
  #      "$mod+CTRL+SHIFT, Q, exec, killall -9 Hyprland"   # Force quit (unsafe)
  #    ]
  #    ++ (
  #        # workspaces
  #        #  $mod + [shift +] {1..10} to [move to] workspace {1..10}
  #        builtins.concatLists (builtins.genList (
  #            x: let
  #              ws = let
  #                c = (x + 1) / 10;
  #              in
  #                builtins.toString (x + 1 - (c * 10));
  #            in [
  #              "$mod, ${ws}, workspace, ${toString (x + 1)}"
  #              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
  #            ]
  #          )
  #          10)
  #    );

  #    bindm = [
  #      "$mod, mouse:272, movewindow"          # MOD + left click: move window
  #      "$mod, mouse:273, resizewindow"        # MOD + right click: resize window
  #      "$mod, mouse:274, togglefloating"      # MOD + middle click: toggle floating
  #    ];

  #    general = {
  #      border_size = "2";
  #      gaps_in = "3";
  #      gaps_out = "5";
  #      layout = "dwindle";
  #      resize_on_border = "true";
  #    };

  #    decoration = {
  #      rounding = "5";
  #    };

  #    misc = {
  #      key_press_enables_dpms = "true";
  #      animate_manual_resizes = "true";
  #      animate_mouse_windowdragging = "true";
  #      vrr = "1";
  #    };

  #    xwayland = {
  #      force_zero_scaling = "true";
  #    };

  #    dwindle = {
  #      #smart_split = "true";
  #      force_split = "2";
  #    };

  #    gestures = {
  #      workspace_swipe = "true";
  #    };

  #    input = {
  #      touchpad = {
  #        disable_while_typing = "false";
  #        natural_scroll = "true";
  #        clickfinger_behavior = "true";
  #        tap-and-drag = "true";
  #      };
  #    };
  #  };

  #  extraConfig = ''
  #    #env = LIBVA_DRIVER_NAME,nvidia
  #    #env = XDG_SESSION_TYPE,wayland
  #    #env = GBM_BACKEND,nvidia-drm
  #    #env = __GLX_VENDOR_LIBRARY_NAME,nvidia
  #    #env = NVD_BACKEND,direct
  #    env = HYPRCURSOR_THEME,MyCursor
  #    env = HYPRCURSOR_SIZE,20
  #    env = XCURSOR_THEME,MyCursor
  #    env = XCURSOR_SIZE,20

  #    exec-once = dbus-update-activation-environment --systemd --all
  #    exec-once = dunst & waybar & hyprpaper & nm-applet
  #  '';
  #};

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8Edx73smHc+THz5F3EaC87Fse7Q1LKLOs1M/gfm+9N 29309688+beeaniebee@users.noreply.github.com";
        signByDefault = true;
      };
      settings = {
        user.email = "29309688+beeaniebee@users.noreply.github.com";
        user.name = "beeaniebee";
        credential.username = "beeaniebee";
        gpg = {
          enable = true;
          format = "ssh";
        };
      };
    };
    ssh = {
      enable = true;
      matchBlocks."*" = {
        addKeysToAgent = "yes";
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;

      initContent = ''
        function lk() {
          cd -- "$(walk --icons "$@")"
        }
      '';

      shellAliases = {
        #  stdp = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p steam-run --run 'steam-run ~/Documents/Mods/Stardrop/Internal $@'";
        updnix = "nix flake update --flake ~/.nixos-config && sudo nixos-rebuild switch --flake ~/.nixos-config/#nixos";
        clean = "sudo nix-collect-garbage -d;nix-collect-garbage -d";
        lsgen = "sudo nix-env --list-generations";
        delgen = "sudo /run/current-system/bin/switch-to-configuration boot";
      };
      syntaxHighlighting.enable = true;
      autocd = true;

      history = {
        size = 10000;
        share = true;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ ];
        theme = "gentoo";
      };
    };

    #hyprlock = {
    #  enable = true;
    #  settings = {
    #    general = {
    #      disable_loading_bar = true;
    #      grace = 300;
    #      hide_cursor = true;
    #      no_fade_in = false;
    #    };

    #    background = [
    #      {
    #        path = "~/.wallpaper.png";
    #        blur_passes = 3;
    #        blur_size = 8;
    #      }
    #    ];

    #    input-field = [
    #      {
    #        size = "200, 50";
    #        position = "0, -80";
    #        monitor = "";
    #        dots_center = true;
    #        fade_on_empty = false;
    #        font_color = "rgb(202, 211, 245)";
    #        inner_color = "rgb(91, 96, 120)";
    #        outer_color = "rgb(24, 25, 38)";
    #        outline_thickness = 5;
    #        placeholder_text = "Enter Password...";
    #        shadow_passes = 2;
    #      }
    #    ];
    #  };
    #};
  };

  services = {
    blueman-applet.enable = true;
    #gpg-agent = {
    #  enable = true;
    #  defaultCacheTtl = 34560000;
    #  maxCacheTtl = 34560000;
    #  pinentryPackage = pkgs.pinentry-qt;
    #  enableScDaemon = false;
    #};

    #dunst = {
    #  enable = true;
    #};

    #hypridle = {
    #  enable = true;
    #  settings = {
    #    general = {
    #      after_sleep_cmd = "hyprctl dispatch dpms on";
    #      ignore_dbus_inhibit = false;
    #      lock_cmd = "hyprlock";
    #    };

    #    listener = [
    #      {
    #        timeout = 30;
    #        on-timeout = "hyprlock";
    #      }
    #      {
    #        timeout = 60;
    #        on-timeout = "hyprctl dispatch dpms off";
    #        on-resume = "hyprctl dispatch dpms on";
    #      }
    #    ];
    #  };
    #};
    #hyprpaper = {
    #  enable = true;
    #  settings = {
    #    ipc = "on";
    #    splash = false;
    #    preload = "~/.wallpaper.png";
    #    wallpaper = "eDP-1,~/.wallpaper.png";
    #  };
    #};
  };

  #systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
