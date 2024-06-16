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
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    #systemd.variables = ["--all"]; if programs don't work in systemd services, but do on the terminal
    settings = {
      "$mod" = "ALT";
    };
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.neovim.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
