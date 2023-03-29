{ modulesPath
, ...
}:

{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  boot = {
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [ "ehci_pci" "uhci_hcd" "ahci" "usbhid" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
