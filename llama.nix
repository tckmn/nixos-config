{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    cfg/basic.nix
    cfg/fonts.nix
    cfg/network.nix
    cfg/nginx.nix
    cfg/packages.nix
    cfg/services.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "zfs" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ]; # for tlp recalibration

  networking.hostName = "llama";
  networking.hostId = "0e4ef622";

  services.xserver.config = ''
    Section "Device"
      Identifier "intelgpu0"
      Driver "intel"
      Option "VirtualHeads" "1"
    EndSection
  '';

  services.earlyoom.enable = true;
  services.earlyoom.freeMemThreshold = 2;
  services.earlyoom.freeSwapThreshold = 2;

  services.tlp.enable = true;
  services.tlp.settings = {
    TLP_ENABLE = 1;
    START_CHARGE_THRESH_BAT0 = 76;
    STOP_CHARGE_THRESH_BAT0  = 80;
    START_CHARGE_THRESH_BAT1 = 76;
    STOP_CHARGE_THRESH_BAT1  = 80;
  };

  services.tckmn_files.enable = true;

  system.stateVersion = "19.03";
}
