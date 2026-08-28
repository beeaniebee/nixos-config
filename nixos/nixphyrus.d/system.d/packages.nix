{ ... }: {
  environment.shellAliases = {
    tpmnrl = "sudo systemd-cryptenroll --tpm2-device=auto /dev/nvme0n1p6 --tpm2-pcrs=0+1+2+3+4+7 --wipe-slot=tpm2 --tpm2-with-pin=yes";
  };
}
