{ ... }: {
  boot.lanzaboote = {
    enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
      includeMicrosoftKeys = true;
      includeFirmwareBuiltinKeys = true;
    };
    measuredBoot = {
      enable = true;
      # pcrs 1 2 3 may be flaky:
      # https://nix-community.github.io/lanzaboote/how-to-guides/enable-measured-boot.html#enable-measured-boot-in-your-config
      # PCR 7 (secure-boot-policy) is also firmware-dependent: not all firmwares
      # emit the systemd-pcrlock-recognized "secureboot-policy" component into
      # the event log. When that happens it's dropped from the protection mask,
      # so leave it out.
      pcrs = [ 0 4 ];
      autoCryptenroll = {
        enable = true;
        device = "/dev/disk/by-uuid/30766688-747e-4138-b70c-a38d16cc7d8d";
        autoReboot = false;
      };
    };
    configurationLimit = 4;
    pkiBundle = "/var/lib/sbctl";
    settings = {
      console-mode = "1";
      editor = false;
      reboot-for-bitlocker = true;
      timeout = 3;
    };
  };
}
