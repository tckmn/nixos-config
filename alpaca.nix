{ config, pkgs, ... }:

{
  imports = [
    "${builtins.fetchGit {
        url = "https://github.com/NixOS/nixos-hardware.git";
        rev = "8251761f93d6f5b91cee45ac09edb6e382641009";
    }}/lenovo/legion/15ach6"
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

  #services.openvpn.servers.proton.config = ''
  #  up ${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf
  #  down ${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf
  #  config /home/tckmn/dl/nl-free-103015.protonvpn.udp.ovpn
  #'';
}
