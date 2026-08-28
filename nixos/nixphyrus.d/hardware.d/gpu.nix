{ inputs, ... }: {
  imports = [ inputs.cardwire.nixosModules.default ];

  services = {
    xserver.videoDrivers = [ "nvidia" "amdgpu" ];
    power-profiles-daemon.enable = true;
    cardwire = {
      enable = true;
      settings = {
        auto_apply_gpu_state = true;
        experimental_nvidia_block = true;
        battery_auto_switch = true;
        battery_auto_switch_mode = "integrated";
      };
    };
  };

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
