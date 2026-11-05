{ ... }: {
  # For enabling Esync: https://github.com/lutris/docs/blob/master/HowToEsync.md
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };
  security.pam.loginLimits = [{
    domain = "beanie";
    type = "hard";
    item = "nofile";
    value = "524288";
  }];
}
