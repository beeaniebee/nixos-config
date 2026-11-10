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
    tpm2-tools
    #**android-tools
  ];
}
