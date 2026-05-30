{ ... }: {
  services = {
    # Zephyrus edits
    supergfxd.enable = true;
    asusd.enable = true;

    # fixes mic mute button
    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
        KEYBOARD_KEY_ff31007c=f20
    '';
  };
}
