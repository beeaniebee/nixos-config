{ config, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autosuggestion.enable = true;

    initContent = ''
      function lk() {
        cd -- "$(walk --icons "$@")"
      }
    '';

    shellAliases = {
      #  stdp = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p steam-run --run 'steam-run ~/Documents/Mods/Stardrop/Internal $@'";
      updnix = "nix flake update --flake ~/.nixos-config && sudo nixos-rebuild switch --flake ~/.nixos-config/#nixos";
      clean = "sudo nix-collect-garbage -d;nix-collect-garbage -d";
      lsgen = "sudo nix-env --list-generations";
      delgen = "sudo /run/current-system/bin/switch-to-configuration boot";
    };
    syntaxHighlighting.enable = true;
    autocd = true;

    history = {
      size = 10000;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "gentoo";
    };
  };
}
