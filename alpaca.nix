{ config, pkgs, options, ... }:

{
  imports = [
    ./hardware-configuration.nix

    cfg/basic.nix
    cfg/fonts.nix
    cfg/network.nix
    # cfg/nginx.nix
    cfg/packages.nix
    cfg/services.nix
  ];

  # TODO fix
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "zfs" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ]; # for tlp recalibration

  networking.hostName = "alpaca";
  networking.hostId = "0e4ef623";

  # TODO fix
  system.stateVersion = "19.03";
}
