{ config, pkgs, ... }:

{
  networking.hostName = "llama";
  networking.hostId = "0e4ef622";
  networking.wireless.iwd.enable = true;
  networking.useNetworkd = true;
  networking.useDHCP = false;
  networking.enableIPv6 = false;

  services.resolved.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true;

  # use cloudflare dns instead of network-provided
  systemd.network.networks."99-main".dns = [ "1.1.1.1" "1.0.0.1" ];
  systemd.network.networks."99-main".DHCP = "yes";
  services.resolved.extraConfig = "[Resolve]\nDNS=1.1.1.1 1.0.0.1";

  # have localhost
  systemd.network.networks."01-lo" = {
    matchConfig = { Name = "lo"; };
    address = [ "127.0.0.1" ];
  };

  # tell systemd not to wait until network connects to do things
  systemd.services.systemd-networkd-wait-online.enable = false;
}
