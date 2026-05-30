{ ... }: {
  imports = [
    ./home.nix
    ./xdg.nix
    ./gtk.nix
    ./packages.nix
    ./home-manager.nix
    ./git.nix
    ./ssh.nix
    ./zsh.nix
    ./blueman-applet.nix
    ./hypr.nix
    ./gpg-agent.nix
    ./state.nix
  ];
}
