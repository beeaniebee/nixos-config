{ ... }: {
  imports = [
    ./services.d/blueman-applet.nix
    ./services.d/gpg-agent.nix
  ];
}
