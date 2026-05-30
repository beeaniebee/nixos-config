{ ... }: {
  security = {
    polkit.enable = true;
    polkit.extraConfig = ''
      // Allow wheel to perform udisks2 disk operations (write/format) with a 1-time auth
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel") &&
            action.id.indexOf("org.freedesktop.udisks2.") === 0) {
          return polkit.Result.AUTH_ADMIN_KEEP; // prompt once, cache
        }
      });
    '';
  };
}
