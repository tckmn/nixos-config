{ config, pkgs, options, ... }:

{
  services.localtime.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  sound.enable = true;
  sound.extraConfig = ''
    pcm.pulse { type pulse }
    ctl.pulse { type pulse }
  '';
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull; # for bluetooth support
  hardware.opengl.driSupport32Bit = true;
  hardware.bluetooth.enable = true;

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.i3.enable = true;
    layout = "us";
    libinput.enable = true;
    libinput.touchpad.tapping = false;
  };
  services.logind.lidSwitchDocked = "suspend";

  users.users.tckmn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "adbusers" "dialout" "jackaudio" "docker" ];
    shell = pkgs.zsh;
  };
  users.users.root.shell = pkgs.zsh;

  nix.trustedUsers = [ "root" "tckmn" ];
  nix.nixPath = options.nix.nixPath.default ++ [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ];
}
