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
    #minecraft - marked as broken, refusing to evaluate
    steam
    blender
    epson-escpr2
    printrun
    discord
    google-chrome
    thunderbird
    vlc
    onlyoffice-bin
    pdfarranger
    solaar
    polychromatic
  ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
