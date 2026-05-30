{ ... }: {
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

  hardware = {
    amdgpu.initrd.enable = true;

    nvidia = {
      open = true;
      modesetting.enable = true;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        amdgpuBusId = "PCI:101:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      powerManagement = {
        enable = true;
        finegrained = true;
      };
    };
  };
}
