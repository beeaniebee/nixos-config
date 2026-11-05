{ ... }: {
  imports = [
    ./programs.d/zsh.nix
    ./programs.d/steam.nix
    ./programs.d/nix-ld.nix
    ./programs.d/localsend.nix
    ./programs.d/git.nix
    ./programs.d/lutris.nix
    ./programs.d/packages.nix
  ];
}
