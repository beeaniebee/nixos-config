{ ... }: {
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "lavender";
    cursors.enable = true;
    # Icons are handled by gtk.iconTheme (COSMIC) in programs.d/gtk.nix.
    gtk.icon.enable = false;
  };
  home.pointerCursor.enable = true;
}
