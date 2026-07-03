{ pkgs, ... }: {
  powerManagement.powertop.enable = true;

  systemd.services.power-profiles-daemon-config = {
    description = "Configure AMD battery saving actions";
    after = [ "power-profiles-daemon.service" ];
    bindsTo = [ "power-profiles-daemon.service" ];
    wantedBy = [ "power-profiles-daemon.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl configure-action amdgpu_panel_power --enable
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl configure-action amdgpu_dpm --enable
    '';
  };

  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=1
    options iwlwifi power_save=1
  '';
}
