{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    cfg/fonts.nix
    cfg/network.nix
    cfg/systemd-user-services.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "zfs" ];

  time.timeZone = "America/Chicago";
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs;
  builtins.filter ( x: builtins.typeOf x != "string" ) [

    ### BASE
    "wm"        i3 i3blocks rofi
    "terminal"  termite zsh neovim tmux git
    "misc"      dunst libnotify xss-lock slock redshift

    ### APPLICATIONS
    "internet"  firefox chromium w3m tdesktop
    "games"     steam
    "mail"      mutt isync notmuch notmuch-mutt newsboat
    "puzzles"   sgtpuzzles qxw
    "misc"      wine

    ### MEDIA
    "edit"      gimp inkscape audacity imagemagick ffmpeg musescore
    "capture"   maim slop simplescreenrecorder
    "view"      feh zathura timidity mpv
    "play"      mpd mpc_cli ncmpcpp
    "tools"     pavucontrol

    ### PROGRAMMING LANGUAGES
    "ruby"      ruby pry
    "python"    python python2
    "latex"     texlive.combined.scheme-small
    "misc"      perl jdk ghc rustup julia racket-minimal jq bc

    ### UTILITIES
    "files"     zip unzip renameutils file stow xdg-user-dirs
    "sys info"  htop acpi tlp sysstat psmisc light
    "xorg"      xorg.xmodmap xdotool xsel
    "internet"  wget youtube-dl
    "packaging" patchelf bundix
    "security"  pass gnupg pinentry_ncurses
    "fun"       fortune cowsay espeak
    "misc"      rlwrap

  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    ( import ./overlays/custom-pkg.nix "pry" )
    ( import ./overlays/custom-pkg.nix "qxw" )
    ( import ./overlays/sudo-0xinsults.nix )
  ];

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.zsh.enable = true;
  programs.slock.enable = true;
  programs.light.enable = true;

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

  services.locate = {
    enable = true;
    localuser = null;
    locate = pkgs.mlocate;
    prunePaths = [ "/tmp" "/var/tmp" "/var/cache" "/var/lock" "/var/run" "/var/spool" "/nix/store" "/mnt" ];
  };

  users.users.tckmn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    shell = pkgs.zsh;
  };
  users.users.root.shell = pkgs.zsh;

  system.stateVersion = "19.03";
}
