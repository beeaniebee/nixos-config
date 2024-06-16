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
      bind = $mod, F, exec, firefox
      bind = $mod enter, exec, kitty

      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = NVD_BACKEND,direct

      cursor {
          no_hardware_cursors = true
      }

      exec-once = dunst
      exec-once = waybar

    '';
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    neovim.enable = true;
    hyprlock.enable = true;
  };
  security.pam.services.hyprlock = {};

  services.hypridle.enable = true;
  services.hyprpaper.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
