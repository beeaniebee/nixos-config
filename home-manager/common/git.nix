{ ... }: {
  programs.git = {
    enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8Edx73smHc+THz5F3EaC87Fse7Q1LKLOs1M/gfm+9N 29309688+beeaniebee@users.noreply.github.com";
      signByDefault = true;
    };
    settings = {
      user.email = "29309688+beeaniebee@users.noreply.github.com";
      user.name = "beeaniebee";
      credential.username = "beeaniebee";
      gpg = {
        enable = true;
        format = "ssh";
      };
    };
  };
}
