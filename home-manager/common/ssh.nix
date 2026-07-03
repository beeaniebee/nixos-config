{ ... }: {
  programs.ssh = {
    enable = true;
    settings."*" = {
      AddKeysToAgent = "yes";
    };
  };
}
