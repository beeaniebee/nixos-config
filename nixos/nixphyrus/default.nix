{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ./gpu.nix
    ./asus.nix
    ./powersave.nix
    ./networking.nix
    ./packages.nix
  ];
}
