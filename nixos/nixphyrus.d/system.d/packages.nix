{ ... }: {
  environment.shellAliases = {
    tpmnrl = "sudo systemd-cryptenroll --tpm2-device=auto /dev/disk/by-uuid/30766688-747e-4138-b70c-a38d16cc7d8d --wipe-slot=tpm2 --tpm2-with-pin=yes";
  };
}
