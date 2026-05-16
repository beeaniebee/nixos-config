{ config, lib, pkgs, inputs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    optimise.automatic = true;
    #registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    #nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  # Select internationalisation properties.
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    interfaces.wlp3s0.useDHCP = true;
  };

  boot = {
    initrd.systemd.enable = true;
    blacklistedKernelModules = [ "nouveau" ];

    # These flags are used to enable backlight control when the dGPU is working in hybrid mode
    kernelParams = [
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
      "mem_sleep_default=sleep"
      "pcie_aspm.policy=powersupersave"
      "amd-pstate=active"
    ];

    loader = {
      # (Lanzaboote) DON'T Use the systemd-boot EFI boot loader.
      systemd-boot.enable = lib.mkForce false;
      #efi.canTouchEfiVariables = true;
      #efi.efiSysMountPoint = "/boot/efi";
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  users.users = {
    beanie = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
      #**openssh.authorizedKeys.keys = [
      #**  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8Edx73smHc+THz5F3EaC87Fse7Q1LKLOs1M/gfm+9N beeaniebee"
      #**];
    };
  };

  services = {
    printing.enable = true;
    fstrim.enable = true;
    flatpak.enable = true;
    udisks2.enable = true;
    fwupd.enable = true;
    #libinput.enable = true;

    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;

    # fixes mic mute button
    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
        KEYBOARD_KEY_ff31007c=f20
    '';

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" "amdgpu" ];

      # Configure keymap in X11
      xkb.layout = "us";
      # xkb.options = "eurosign:e,caps:escape";
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    #usbmuxd = {
    #  enable = true;
    #  package = pkgs.usbmuxd2;
    #};

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Zephyrus edits
    supergfxd.enable = true;
    asusd.enable = true; #**
  };

  hardware = {
    amdgpu.initrd.enable = true;
    graphics = {
      enable = true;
      #enable32bit = true;
    };

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

    #bluetooth = {
    #  enable = true;
    #  package = pkgs.bluez;
    #  #powerOnBoot = true;
    #  settings = {
    #    General = {
    #      Enable = "Source,Sink,Media,Socket";
    #      ControllerMode = "dual";
    #      FastConnectable = "true";
    #      Experimental = "true";
    #     };
    #    Policy = {
    #      AutoEnable = "true";
    #    };
    #  };
    #};
  };

  security = {
    polkit.enable = true;
    polkit.extraConfig = ''
      // Allow wheel to perform udisks2 disk operations (write/format) with a 1-time auth
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel") &&
            action.id.indexOf("org.freedesktop.udisks2.") === 0) {
          return polkit.Result.AUTH_ADMIN_KEEP; // prompt once, cache
        }
      });
    '';
  };

  # List packages installed in system profile.
  programs = {
    zsh.enable = true;
    localsend.enable = true;
    #ssh.startAgent = true; #**
    steam.enable = true; #**
    nix-ld.enable = true; #**
    git.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    sbctl
    pciutils
    usbutils
    gparted
    rpi-imager
    #libimobiledevice
    #ifuse
    vlc #**
    libvlc #**
    #**android-tools
  ];

  system.stateVersion = "26.05";
}
