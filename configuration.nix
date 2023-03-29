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
  sound.extraConfig = ''
    pcm.pulse { type pulse }
    ctl.pulse { type pulse }
  '';
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull; # for bluetooth support
  hardware.opengl.driSupport32Bit = true;
  hardware.bluetooth.enable = true;

  # services.jack = {
  #   jackd.enable = true;
  #   alsa.enable = false;
  #   loopback.enable = true;
  # };

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.tapping = false;
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

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "andy@tck.mn";
  security.acme.certs."tsetse.tck.mn".extraDomainNames = [
    "dyn.tck.mn"
    "pzplus.tck.mn"
  ];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "tsetse.tck.mn" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5353";
        };
        locations."/ws/" = {
          proxyPass = "http://127.0.0.1:5354";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_read_timeout 86400;
          '';
        };
      };
      "pzplus.tck.mn" = {
        forceSSL = true;
        useACMEHost = "tsetse.tck.mn";
        locations."/" = {
          proxyPass = "http://127.0.0.1:2345";
        };
      };
      "dyn.tck.mn" = {
        forceSSL = true;
        useACMEHost = "tsetse.tck.mn";
        locations."/" = {
          proxyPass = "http://127.0.0.1:1729";
          extraConfig = ''
            add_header 'Access-Control-Allow-Origin' 'https://tck.mn' always;
            add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, DELETE, PUT' always;
            add_header 'Access-Control-Allow-Credentials' 'true' always;
            add_header 'Access-Control-Allow-Headers' 'User-Agent,Keep-Alive,Content-Type' always;
          '';
        };
      };
    };
  };

  # virtualisation.docker.enable = true;

  users.users.tckmn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "adbusers" "dialout" "jackaudio" "docker" ];
    shell = pkgs.zsh;
  };
  users.users.root.shell = pkgs.zsh;

  nix.trustedUsers = [ "root" "tckmn" ];
  nix.nixPath = options.nix.nixPath.default ++ [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ];

  system.stateVersion = "19.03";
}
