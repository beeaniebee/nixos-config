{ pkgs, ... }: {
  services = {
    desktopManager.gnome.enable = true;
    gnome = {
      core-apps.enable = true;
      core-developer-tools.enable = false;
      games.enable = false;
    };
  };
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.paperwm
  ];

  programs.dconf = {
    enable = true;
    profiles."user".databases = [
      {
        settings."org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [ "paperwm@paperwm.github.com" ];
        };
      }
    ];
  };
}
