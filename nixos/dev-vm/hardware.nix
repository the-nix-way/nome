# PLACEHOLDER: the boot loader and disk layout depend on the cloud provider, which isn't chosen
# yet. These values assume a UEFI KVM guest and exist so that the configuration evaluates.
# Replace this file with the provider's real settings before deploying.
{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader = {
    efi.canTouchEfiVariables = false;
    systemd-boot.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };
}
