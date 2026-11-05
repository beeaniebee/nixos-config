{ ... }: {
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "lavender";
    # Use Catppuccin's binary cache for theme packages.
    cache.enable = true;
    # System-wide (non-home-manager) ports.
    cursors.enable = true;
    tty.enable = false;
    gtk.icon.enable = false;
    # Lanzaboote/systemd-boot is used instead of GRUB.
    grub.enable = false;
  };
}
