{ ... }: {
  swapDevices = [ { device = "/var/swapfile"; size = 32*1024; } ];

  boot.kernelParams = ["resume-offset=3713024"];
  boot.resumeDevice = "/dev/disk/by-uuid/b6c8dbf8-577d-47c6-a53d-e886df9dafdb";

  powerManagement.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };

  systemd.sleep.settings.Sleep.HibernateDelaySec = "60m";
}
