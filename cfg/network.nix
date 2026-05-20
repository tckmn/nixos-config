{ config, pkgs, ... }:

{
  networking.wireless.iwd.enable = true;
  # networking.wireless.iwd.settings = {
  #   General = {
  #     RoamThreshold = -80;
  #     RoamThreshold5G = -82;
  #   };
  # };
  networking.hosts = { "127.0.0.1" = [ "localhost.tck.mn" ]; };
  networking.firewall.enable = false;

  services.openssh.enable = true;
  services.printing.enable = true;
  #services.printing.drivers = [ pkgs.hplipWithPlugin ];
  #services.printing.drivers = [ pkgs.brlaser ];
  #services.avahi = {
  #  enable = true;
  #  nssmdns4 = true;
  #  openFirewall = true;
  #};
}
