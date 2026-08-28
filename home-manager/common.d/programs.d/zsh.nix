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
      bootupd = "nix flake update --flake ~/.nixos-config && sudo nixos-rebuild boot --flake ~/.nixos-config/#nixos";
      clean = "sudo nix-collect-garbage -d;nix-collect-garbage -d";
      lsgen = "sudo nix-env --profile /nix/var/nix/profiles/system --list-generations";
      delgen = "sudo /run/current-system/bin/switch-to-configuration boot";
      pwr = "echo - | awk '{printf \"%.1f\", $(( $(cat /sys/class/power_supply/BAT1/current_now) * $(cat /sys/class/power_supply/BAT1/voltage_now) )) / 1f000000000000 }' ; echo \" W \"";
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
