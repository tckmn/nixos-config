{ config, pkgs, options, ... }:

{
  services.localtimed.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  #sound.enable = true;
  #sound.extraConfig = ''
  #  pcm.pulse { type pulse }
  #  ctl.pulse { type pulse }
  #'';
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;
  #hardware.pulseaudio.package = pkgs.pulseaudioFull; # for bluetooth support
  hardware.graphics.enable32Bit = true;
  hardware.bluetooth.enable = true;

  #hardware.bluetooth.settings = {
  #  General = {
  #    FastConnectable = true;
  #  };
  #};
  #hardware.bluetooth.input = {
  #  General = {
  #    ClassicBondedOnly = false;
  #  };
  #};
  #hardware.bluetooth.package = (import (builtins.fetchTarball {
  #  url = "https://github.com/NixOS/nixpkgs/archive/ee25468a270e100ed6e055f81937559d5d217048.tar.gz";
  #  url = "https://github.com/NixOS/nixpkgs/archive/37cac5f032f6da598eddde8dd49eb7a820d72ea3.tar.gz";
  #}) {}).bluezFull;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.i3.enable = true;
    xkb.layout = "us";
  };
  services.libinput = {
    enable = true;
    touchpad.tapping = true;
  };
  services.logind.settings.Login.HandleLidSwitchDocked = "suspend";

  users.users.tckmn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "adbusers" "dialout" "jackaudio" "docker" "input" ];
    shell = pkgs.zsh;
  };
  users.users.root.shell = pkgs.zsh;

  nix.nixPath = options.nix.nixPath.default ++ [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ];

  nix.settings.trusted-users = [ "root" "tckmn" ];
  nix.settings.experimental-features = "nix-command flakes";
}
