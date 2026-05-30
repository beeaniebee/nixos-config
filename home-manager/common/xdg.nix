{ ... }: {
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
}
