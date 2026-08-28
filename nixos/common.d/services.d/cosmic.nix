{ ... }: {
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
  };
}
