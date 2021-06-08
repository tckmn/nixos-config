{ config, pkgs, options, ... }:

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
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ]; # for tlp recalibration

  services.localtime.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull; # for bluetooth support
  hardware.opengl.driSupport32Bit = true;
  hardware.bluetooth.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.xserver.libinput.tapping = false;
  services.xserver.config = ''
    Section "Device"
      Identifier "intelgpu0"
      Driver "intel"
      Option "VirtualHeads" "1"
    EndSection
  '';
  services.logind.lidSwitchDocked = "suspend";

  services.earlyoom.enable = true;
  services.earlyoom.freeMemThreshold = 2;
  services.earlyoom.freeSwapThreshold = 2;

  users.users.tckmn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "adbusers" "dialout" ];
    shell = pkgs.zsh;
  };
  users.users.root.shell = pkgs.zsh;

  nix.trustedUsers = [ "root" "tckmn" ];
  nix.nixPath = options.nix.nixPath.default ++ [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ];

  system.stateVersion = "19.03";
}
