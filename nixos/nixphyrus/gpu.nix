{ pkgs, ... }: {
  services = {
    xserver.videoDrivers = [ "nvidia" "amdgpu" ];
    power-profiles-daemon.enable = true;
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

  systemd.services.power-profiles-daemon-config = {
    description = "Configure AMD battery saving actions";
    after = [ "power-profiles-daemon.service" ];
    bindsTo = [ "power-profiles-daemon.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl configure-action amdgpu_panel_power --enable
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl configure-action amdgpu_dpm --enable
    '';
  };
}
