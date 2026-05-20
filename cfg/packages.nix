{ config, pkgs, ... }:

#let nixpkgs_biber = import (builtins.fetchTarball {
#    url = "https://github.com/NixOS/nixpkgs/archive/80c24eeb9ff46aa99617844d0c4168659e35175f.tar.gz";
#    sha256 = "0a2cws2hhdi4j5ipn1rsk5k7b6vw1l29ibb020bvgl9mza51psgl";
#}) {}; in
{
  environment.systemPackages = with pkgs;
  builtins.filter ( x: builtins.typeOf x != "string" ) [

    ### BASE
    " wm        " i3 i3blocks rofi ppi3
    " terminal  " alacritty neovim tmux git
    " misc      " dunst libnotify equilux-theme adwaita-qt

    ### APPLICATIONS
    " browsers  " firefox chromium
    " chat      " telegram-desktop signal-desktop #ripcord irssi skypeforlinux zoom-us pidgin discord
    " games     " steam steam-run the-powder-toy obs-studio
    " emulators " #fceux dolphinEmu mupen64plus
    " mail      " mutt isync notmuch notmuch-mutt #cyrus_sasl newsboat
    " puzzles   " sgt-puzzles qxw
    " misc      " anki wineWowPackages.stable libreoffice

    ### MEDIA
    " edit      " gimp inkscape audacity imagemagick ffmpeg musescore lmms lilypond #sunvox
    " capture   " maim slop simplescreenrecorder
    " view      " feh zathura timidity mpv
    " play      " mpd mpc (ncmpcpp.override { visualizerSupport = true; })
    " download  " #youtube-dl bandcamp-dl
    " tools     " pavucontrol qpwgraph picard optipng adb-sync #qjackctl

    ### PROGRAMMING
    " c         " gcc clang gnumake cmake gdb man-pages
    " ruby      " ( ruby.withPackages ( p : with p; [ nokogiri pry ] ) )
    " python2   " #( python27.withPackages ( p : with p; [] ))
    " python3   " python3 #( python38.withPackages ( p : with p; [ requests virtualenv ] ))
    " haskell   " ghc stack
    " java      " openjdk gradle
    " web       " nodejs typescript sassc
    " misc      " coq jq tectonic bc racket-minimal sqlite-interactive cargo rustc #perl rustup jelly j mono sass gnuplot agda unstable.mathematica julia_13
    " tools     " universal-ctags google-cloud-sdk

    ### UTILITIES
    " files     " renameutils binutils moreutils file xdg-user-dirs xxd ripgrep fd
    " compress  " zip unzip p7zip
    " documents " djvu2pdf pandoc pdftk poppler cmark
    " sys info  " htop acpi sysstat psmisc #tlp
    " xorg      " xorg.xmodmap xorg.xkbcomp xorg.xev xorg.xwininfo xdotool xsel #x11vnc
    " internet  " wget iftop w3m lighttpd #transmission iftop
    " packaging " #patchelf bundix nix-index
    " security  " pass pinentry-curses oath-toolkit
    " fun       " bsdgames fortune cowsay xcowsay cmatrix figlet #espeak ipbt ttyrec
    " misc      " shell-scripts #rlwrap

    ### TEMPORARY
    #mma
    #nixpkgs_biber.biber
    #flatpak
    #jmtpfs
    #plover.dev
    #appimage-run

  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    # ( import ../overlays/custom-pkg.nix "bandcamp-dl" )
    # ( import ../overlays/custom-pkg.nix "discordrb" )
    # ( import ../overlays/custom-pkg.nix "ipbt" )
    # ( import ../overlays/custom-pkg.nix "jelly" )
    # ( import ../overlays/custom-pkg.nix "pry" )
    # ( import ../overlays/custom-pkg.nix "pygame" )
    # ( import ../overlays/discord.nix )
    # ( import ../overlays/fix-pyflakes.nix )
    # ( import ../overlays/pidgin.nix ( with pkgs; [ purple-hangouts ] ) )
    ( import ../overlays/custom-pkg.nix "ppi3" )
    ( import ../overlays/custom-pkg.nix "qxw" )
    # ( import ../overlays/custom-pkg.nix "mma" )
    ( import ../overlays/custom-pkg.nix "shell-scripts" )
    ( import ../overlays/custom-pkg.nix "shemicolon" )
    ( import ../overlays/jconsole-priority.nix )
    #( import ../overlays/sudo-0xinsults.nix )
    #( import ../overlays/unstable.nix )
  ];

  programs.zsh = {
    enable = true;
    interactiveShellInit = with pkgs; ''
      source ${zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      source ${shemicolon}/share/shemicolon/shemicolon.zsh
    '';
  };

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.light.enable = true;
  programs.adb.enable = true;
  programs.firejail.enable = true;
  programs.mosh.enable = true;
  programs.dconf.enable = true;
  programs.direnv.enable = true;

  programs.slock.enable = true;
  # programs.xss-lock.enable = true;
  # programs.xss-lock.lockerCommand = "${pkgs.slock}/bin/slock";

  services.redshift.enable = true;
  location.provider = "geoclue2";

}
