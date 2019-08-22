{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    cfg/fonts.nix
    cfg/network.nix
    cfg/packages.nix
    cfg/services.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "zfs" ];

  time.timeZone = "America/New_York";
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.bluetooth.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.xserver.libinput.tapping = false;
  services.logind.lidSwitchDocked = "suspend";

  users.users.tckmn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    shell = pkgs.zsh;
  };
  users.users.root.shell = pkgs.zsh;

  system.stateVersion = "19.03";
}
