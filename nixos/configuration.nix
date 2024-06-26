# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
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
  ];

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

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

    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  networking.hostName = "nixtop";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot/efi";
    initrd.systemd.enable = true;
  };

  users.users = {
    beanie = {
      initialPassword = "nixos";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "openrazer" ];
      shell = pkgs.zsh;
    };
  };

  services = {
    printing.enable = true;
    blueman.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      catppuccin.enable = true;
      wayland.enable = true;
    };

    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ]; #"nvidia" ];
    };

    usbmuxd = {
      #TODO: re-enable later
      enable = false;#true;
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
    thunar = {  
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
      ];
    };
  };

  sound.enable = true;
  security.rtkit.enable = true;

  hardware = {
    pulseaudio.enable = false;
    openrazer.enable = true;

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

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    pavucontrol
    plasma-pa
    libimobiledevice
    ifuse
    power-profiles-daemon
    openrazer-daemon
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
    ark
    
  ];

  security.pam.services.hyprlock = {};

  system.stateVersion = "24.05";
}
