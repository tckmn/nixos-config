{ config, pkgs, ... }:

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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  networking.hostName = "alpaca";
  networking.hostId = "0e4ef623";

  system.stateVersion = "22.11";
}
