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

  programs.neovim.enable = true;
  home.packages = with pkgs; [
    firefox
    kate
    cura
    vscode
    qalculate-qt
    octave
    logisim-evolution
    minecraft
    steam
    blender
    epson-escpr2
    printrun
    discord
    google-chrome
    thunderbird
    vlc
    obsidian
    onlyoffice-bin
    pdfarranger
    solaar
  ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
