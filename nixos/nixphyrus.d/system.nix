{ ... }: {
  imports = [
    ./system.d/networking.nix
    ./system.d/hibernate.nix
    ./system.d/packages.nix
  ];
}
