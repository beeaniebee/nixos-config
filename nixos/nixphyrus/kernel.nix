{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    blacklistedKernelModules = [ "nouveau" ];

    # These flags are used to enable backlight control when the dGPU is working in hybrid mode
    kernelParams = [
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
      "mem_sleep_default=deep"
      "pcie_aspm.policy=powersupersave"
      "amd-pstate=active"
    ];
  };
}
