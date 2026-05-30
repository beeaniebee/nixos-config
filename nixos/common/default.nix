{ ... }: {
  imports = [
    ./boot.nix
    ./state.nix
    ./nix.nix
    ./locale.nix
    ./networking.nix
    ./users.nix
    ./secureboot.nix
    ./printing.nix
    ./flatpak.nix
    ./udisks2.nix
    ./fwupd.nix
    ./pipewire.nix
    ./cosmic.nix
    ./avahi.nix
    ./fstrim.nix
    ./polkit.nix
    ./graphics.nix
    ./zsh.nix
    ./steam.nix
    ./nix-ld.nix
    ./localsend.nix
    ./git.nix
    ./packages.nix
  ];
}
