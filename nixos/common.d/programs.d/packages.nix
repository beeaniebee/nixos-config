{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    sbctl
    pciutils
    usbutils
    gparted
    rpi-imager
    #libimobiledevice
    #ifuse
    vlc
    libvlc
    #**android-tools
  ];
}
