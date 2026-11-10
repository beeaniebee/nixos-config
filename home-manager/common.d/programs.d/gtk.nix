{ pkgs, ... }: {
  gtk = {
    enable = true;
    font = {
      name = "Fantasque Sans Mono Nerd Font";
    };
    iconTheme = {
      name = "Cosmic";
      package = pkgs.cosmic-icons;
    };
  };
}
