{ ... }: {
  home = {
    username = "beanie";
    homeDirectory = "/home/beanie";
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      #EDITOR = lib.mkForce "lvim";
    };
    enableNixpkgsReleaseCheck = false;
  };
}
