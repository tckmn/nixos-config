{ config, pkgs, ... }:

{
  networking.hostName = "llama";
  networking.hostId = "0e4ef622";
  networking.wireless.iwd.enable = true;
  networking.useDHCP = false;
  networking.interfaces.wlan0.useDHCP = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.hosts = { "127.0.0.1" = [ "vfr.tck.mn" ]; };
  networking.firewall.enable = false;
  # networking.enableIPv6 = false;

  services.openssh.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];
}
