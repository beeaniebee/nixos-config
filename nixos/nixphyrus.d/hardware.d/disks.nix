{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
      luks.devices."root".device = "/dev/disk/by-uuid/30766688-747e-4138-b70c-a38d16cc7d8d";
    };
  };
  fileSystems = {
    "/" = {
      device = "/dev/mapper/root";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/EA01-F6EB";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
}
