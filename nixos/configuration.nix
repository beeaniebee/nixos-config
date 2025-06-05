# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  #pkgs-unstable,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    optimise.automatic = true;
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";
  networking.hostName = "nixos-hp";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";

  catppuccin = {
    enable = true;
    flavor = "mocha";
    sddm.enable = true;
  };

  boot = {
    loader = {
        systemd-boot.enable = lib.mkForce false;
        efi.canTouchEfiVariables = true;
        efi.efiSysMountPoint = "/boot/efi";
    };

    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    initrd = {
      systemd.enable = true;
      # Setup keyfile
      secrets = {
        "/crypto_keyfile.bin" = null;
      };

      # Enable swap on luks
      luks.devices."luks-37c02b36-d69d-4de1-af29-7736f35d93f5".device = "/dev/disk/by-uuid/37c02b36-d69d-4de1-af29-7736f35d93f5";
      luks.devices."luks-37c02b36-d69d-4de1-af29-7736f35d93f5".keyFile = "/crypto_keyfile.bin";

    };
  };

  users.users = {
    beanie = {
      initialPassword = "nixos";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "openrazer" "input" "libvirtd" ];
      shell = pkgs.zsh;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fantasque-sans-mono
  ];

  services = {
    pulseaudio.enable = false;
    printing.enable = true;
    blueman.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    power-profiles-daemon.enable = true;
    #desktopManager.cosmic.enable = true;
    #displayManager.cosmic-greeter.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
    };

    xserver = {
      enable = true;
      xkb.layout = "us";
      desktopManager.cinnamon.enable = true;
      #videoDrivers = [ "amdgpu" ]; #"nvidia" ];
    };
    cinnamon.apps.enable = true;

    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
      wireplumber.extraConfig = {
        "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
        };
      };
    };
  };

  programs = {
    hyprland.enable = true;
    zsh.enable = true;
    xfconf.enable = true;
    gpaste.enable = true;
    kdeconnect.enable = true;
    virt-manager.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
      ];
    };
  };

  security.rtkit.enable = true;
  virtualisation.libvirtd.enable = true;

  hardware = {
    #openrazer.enable = true;

    #nvidia = {
    #  modesetting.enable = true;
    #  open = true;
    #  nvidiaSettings = true;
    #  prime = {
    #    offload = {
    #      enable = true;
    #      enableOffloadCmd = true;
    #    };
    #    amdgpuBusId = "PCI:4:0:0";
    #    nvidiaBusId = "PCI:1:0:0";
    #  };
    #  powerManagement = {
    #    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    #    # Enable this if you have graphical corruption issues or application crashes after waking
    #    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    #    # of just the bare essentials.
    #    enable = true;
    #    # Fine-grained power management. Turns off GPU when not in use.
    #    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    #    finegrained = true;
    #  };
    #};

    bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          ControllerMode = "dual";
          FastConnectable = "true";
          Experimental = "true";
        };
        Policy = {
          AutoEnable = "true";
        };
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      #extraPackages = with pkgs; [
        #rocm-opencl-icd
        #rocm-opencl-runtime
        #amdvlk
      #];
    };
  };

  environment.systemPackages =
  (with pkgs; [
    kdePackages.plasma-pa
    fwupd
    vim
    wget
    git
    curl
    pavucontrol
    libimobiledevice
    ifuse
    power-profiles-daemon
    #openrazer-daemon
    pciutils
    aha
    clinfo
    glxinfo
    vulkan-tools
    wayland-utils
    tpm2-tss
    blueman
    nwg-look
    nwg-hello
    nwg-panel
    virtiofsd
    guestfs-tools
    btrfs-progs
    hfsprogs
    exfatprogs
    inputs.zen-browser.packages."${system}".default
#  )]
#  ++ (with pkgs-unstable; [
    sbctl
  ]);

  #security.pam.services.hyprlock = {};

  networking.firewall = {
      enable = true;
	  # Open ports in the firewall.
		allowedTCPPortRanges = [
	    { from = 1714; to = 1764; } # KDE Connect
	    { from = 42000; to = 42001; } # Warpinator
	  ];
	  allowedUDPPortRanges = [
	    { from = 1714; to = 1764; } # KDE Connect
	    { from = 5353; to = 5353; } # Warpinator
	  ];
    };

  system.stateVersion = "24.11";
}
