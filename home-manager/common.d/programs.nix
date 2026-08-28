{ ... }: {
  imports = [
    ./programs.d/git.nix
    ./programs.d/ssh.nix
    ./programs.d/zsh.nix
    ./programs.d/gtk.nix
    ./programs.d/packages.nix
  ];
}
