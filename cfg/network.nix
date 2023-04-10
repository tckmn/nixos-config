{ config, pkgs, ... }:

{
  networking.wireless.iwd.enable = true;
  networking.hosts = { "127.0.0.1" = [ "localhost.tck.mn" ]; };
  networking.firewall.enable = false;

  services.openssh.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];
}
