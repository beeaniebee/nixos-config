{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ./gpu.nix
    ./asus.nix
    ./networking.nix
    ./packages.nix
  ];
}
