{ ... }: {
  imports = [
    ./system.d/boot.nix
    ./system.d/state.nix
    ./system.d/nix.nix
    ./system.d/locale.nix
    ./system.d/users.nix
    ./system.d/networking.nix
    ./system.d/catppuccin.nix
  ];
}
