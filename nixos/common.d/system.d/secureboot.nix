{ lib, ... }: {
  boot = {
    loader = {
      # (Lanzaboote) DON'T Use the systemd-boot EFI boot loader.
      systemd-boot.enable = lib.mkForce false;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
