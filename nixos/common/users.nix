{ pkgs, ... }: {
  users.users = {
    beanie = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
    };
  };
}
