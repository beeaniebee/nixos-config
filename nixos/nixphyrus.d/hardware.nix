{ ... }: {
  imports = [
    ./hardware.d/hardware-configuration.nix
    ./hardware.d/kernel.nix
    ./hardware.d/gpu.nix
    ./hardware.d/powersave.nix
    ./hardware.d/asus.nix
  ];
}
