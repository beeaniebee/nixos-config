{ ... }: {
  imports = [
    ./system.d/home.nix
    ./system.d/state.nix
    ./system.d/home-manager.nix
    ./system.d/xdg.nix
  ];
}
