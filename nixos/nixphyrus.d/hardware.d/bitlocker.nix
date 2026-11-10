{ pkgs, lib, ... }:

let
  # Unlock/mount a drive only when its mount point is first accessed.
  mountOnAccess = false;

  # Filesystem driver for the Windows C: drive (/winOS):
  #
  #   false -> ntfs-3g: slower (FUSE), but checks hiberfil.sys and the
  #            NTFS log at mount time and automatically falls back to a
  #            read-only mount if Windows is hibernated or unclean.
  #   true  -> ntfs3: in-kernel and faster, but refuses to mount a
  #            hibernated/unclean volume instead of mounting read-only.
  useNtfs3ForWinOS = false;

  # Set to true to unlock without prompting, using root-only key files.
  # BitLocker passwords differ per volume, so each drive needs its own key.
  # Create them once (keep them out of the Nix store):
  #   sudo install -d -m 700 /var/lib/bitlocker
  #   sudo bash -c 'umask 077; read -rsp "Games password: " pw; printf %s "$pw" > /var/lib/bitlocker/games.key; echo'
  #   sudo bash -c 'umask 077; read -rsp "Windows password: " pw; printf %s "$pw" > /var/lib/bitlocker/windows.key; echo'
  #
  # Either the normal BitLocker password or the 48-digit recovery key works.
  # Write it as a single line with no trailing newline.
  useKeyFile = true;

  drives = [
    {
      name = "bitlkgames";
      uuid = "0d7f06ae-d298-42de-91c1-04a4faf47aa4";
      mountPoint = "/games";
      fsType = "ntfs3";
      keyFile = "/var/lib/bitlocker/games.key";
    }
    {
      name = "bitlkwindows";
      uuid = "2cd3867c-afe3-400a-bb3c-3fd343d125b0";
      mountPoint = "/winOS";
      fsType = if useNtfs3ForWinOS then "ntfs3" else "ntfs-3g";
      #
      # Manual hibernation check once the volume is unlocked (ntfs-3g):
      #   sudo ntfs-3g.probe --readwrite /dev/mapper/bitlkwindows; echo $?
      # 0 = clean, 14 = hibernated, 15 = not cleanly unmounted.
      #
      # Note: with Windows Fast Startup enabled, even a normal "shutdown"
      # leaves C: unclean, so ntfs-3g will mount it read-only. Disable
      # Fast Startup (in Windows: powercfg /h off) if you want read-write
      # after shutdown.
      #
      # ntfs3 has no "recover" step, so "norecover" only applies to
      # ntfs-3g. With ntfs-3g, never replay the NTFS log on an unclean
      # volume; just fall back to read-only instead.
      extraMountOptions = lib.optional (!useNtfs3ForWinOS) "norecover";
      keyFile = "/var/lib/bitlocker/windows.key";
    }
  ];

  crypttabOptions = [ "bitlk" ]
    ++ lib.optional useKeyFile "nofail"
    ++ lib.optional mountOnAccess "noauto";

  mountOptions = [
    "nofail"
    "x-systemd.device-timeout=10s"
    "uid=1000" # beanie
    "gid=100" # users
    "umask=007"
  ]
  ++ lib.optionals mountOnAccess [
    "noauto"
    "x-systemd.automount"
    "x-systemd.idle-timeout=600"
  ];

  mkCrypttabEntry = d:
    "${d.name} UUID=${d.uuid} "
    + (if useKeyFile then d.keyFile else "none")
    + " ${lib.concatStringsSep "," crypttabOptions}";

  mkFileSystem = d: {
    device = "/dev/mapper/${d.name}";
    inherit (d) fsType;
    options = mountOptions
      ++ (d.extraMountOptions or [])
      ++ [
        # With noauto in crypttab, the automount must pull in the unlock
        # service itself when the mount point is accessed.
        "x-systemd.requires=systemd-cryptsetup@${d.name}.service"
      ];
    noCheck = true;
  };
in
{
  environment.systemPackages = [ pkgs.cryptsetup ];

  # systemd reads this and creates systemd-cryptsetup@<name>.service for
  # each BitLocker volume. With mountOnAccess = true, the device is only
  # unlocked when the matching mount point is accessed.
  environment.etc.crypttab.text = lib.concatStringsSep "\n" (
    [ "# <name> <device> <password> <options>" ]
    ++ map mkCrypttabEntry drives
  ) + "\n";

  fileSystems = lib.listToAttrs (
    map (d: lib.nameValuePair d.mountPoint (mkFileSystem d)) drives
  );

  # /games always uses ntfs3. /winOS uses ntfs-3g unless
  # useNtfs3ForWinOS is set; ntfs-3g is added to system.fsPackages
  # automatically because of its fsType.
  boot.kernelModules = [ "ntfs3" "fuse" ];
}
