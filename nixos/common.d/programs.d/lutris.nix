{ lib, ... }: let
  # Mount only when the destination directory is first accessed. Set to false to mount at boot instead.
  mountOnAccess = true;

  bindMounts = {
    orderOfTheSinkingStar = {
      enable = true;
      source = "/winOS/Users/Bee/Saved Games/Order of the Sinking Star";
      destination = "/home/beanie/Games/umu/umu-default/drive_c/users/steamuser/Saved Games/Order of the Sinking Star";
    };
    probablyStolen = {
      enable = true;
      source = "/winOS/Users/Bee/AppData/LocalLow/Questing Goose Studio";
      destination = "/home/beanie/Games/umu/umu-default/drive_c/users/steamuser/AppData/LocalLow/Questing Goose Studio";
    };
  };
  enabledMounts = lib.filterAttrs (_: mount: mount.enable or true) bindMounts;
in {
  # For enabling Esync: https://github.com/lutris/docs/blob/master/HowToEsync.md
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };
  security.pam.loginLimits = [{
    domain = "beanie";
    type = "hard";
    item = "nofile";
    value = "524288";
  }];

  # Lutris launches Proton games through umu/pressure-vessel, which exposes
  # /home but not custom top-level mounts such as /winOS. A symlink from the
  # Wine prefix to /winOS therefore breaks inside the container. Bind-mounting
  # the save folder into the prefix makes it a normal directory that is
  # carried into the container.
  #
  # Defined via systemd.mounts/automounts instead of fileSystems so the
  # space-containing destinations avoid switch-to-configuration's fstab
  # parsing (which mishandles `\040`). First switch away from fileSystems
  # must use `boot` + reboot, not `switch`.
  systemd.mounts = map (mount:
    let
      # Default to the top-level mount containing the source (e.g. /winOS for
      # /winOS/...), which is what RequiresMountsFor needs.
      topLevel = "/" + builtins.head (builtins.filter (p: p != "") (lib.splitString "/" mount.source));
      requiresMountsFor = mount.requiresMountsFor or topLevel;
      onAccess = mount.mountOnAccess or mountOnAccess;
    in {
      what = mount.source;
      where = mount.destination;
      type = "none";
      options = mount.options or "bind";
      unitConfig.RequiresMountsFor = requiresMountsFor;
      wantedBy = lib.optionals (!onAccess) [ "multi-user.target" ];
    }) (lib.attrValues enabledMounts);

  systemd.automounts = map (mount: {
    where = mount.destination;
    automountConfig.TimeoutIdleSec = "600";
    wantedBy = [ "multi-user.target" ];
  }) (lib.filter (mount: mount.mountOnAccess or mountOnAccess) (lib.attrValues enabledMounts));
}
