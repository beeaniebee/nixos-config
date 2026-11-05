{ ... }: {
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    settings = {
      console-mode = "1";
      default = "@saved";
      editor = false;
      reboot-for-bitlocker = true;
      timeout = 3;
    };
  };
}
