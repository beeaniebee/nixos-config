{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  networking.hostName = "nixtop";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  users.users = {
    beanie = {
      initialPassword = "nixos";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "openrazer" ];
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs; };
    users = {
      beanie = import ./home.nix;
    };
  };

  services.printing.enable = true;

  services.xserver.enable = true;
  #services.xserver.libinput.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  #environment.plasma6.excludePackages with pkgs.kdePackages; [
  #  # any packages to exclude from KDE Plasma 6
  #];

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  hardware.pulseaudio.enable = false;
  hardware.openrazer.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
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
    openrazer-daemon
    pciutils
    aha
    clinfo
    glxinfo
    vulkan-tools
    wayland-utils
  ];

  services.usbmuxd = {
  #TODO: re-enable later
  enable = false;#true;
  package = pkgs.usbmuxd2;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      amdvlk
    ];
  };
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    powerManagement = {
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      enable = true;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      finegrained = true;
    };
  };

  system.stateVersion = "24.05";
}
