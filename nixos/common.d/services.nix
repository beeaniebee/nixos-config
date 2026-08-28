{ ... }: {
  imports = [
    ./services.d/printing.nix
    ./services.d/flatpak.nix
    ./services.d/udisks2.nix
    ./services.d/fwupd.nix
    ./services.d/pipewire.nix
    ./services.d/avahi.nix
    ./services.d/fstrim.nix
    ./services.d/polkit.nix
    ./services.d/cosmic.nix
    ./services.d/gnome.nix
    ./services.d/graphics.nix
  ];
}
