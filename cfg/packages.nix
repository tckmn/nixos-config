{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  let py = v: e: v.withPackages ( p: with p; [ requests beautifulsoup4 numpy ] ++ e ); in
  builtins.filter ( x: builtins.typeOf x != "string" ) [

    ### BASE
    " wm        " i3 i3blocks rofi ppi3
    " terminal  " termite zsh neovim tmux git
    " misc      " dunst libnotify xss-lock slock redshift equilux-theme

    ### APPLICATIONS
    " browsers  " firefox chromium
    " chat      " tdesktop irssi discord pidgin-with-plugins skype
    " games     " steam the-powder-toy
    " emulators " fceux dolphinEmu mupen64plus
    " mail      " mutt isync notmuch notmuch-mutt newsboat
    " puzzles   " sgtpuzzles qxw
    " misc      " wine libreoffice

    ### MEDIA
    " edit      " gimp inkscape audacity imagemagick ffmpeg musescore lilypond
    " capture   " maim slop simplescreenrecorder
    " view      " feh zathura timidity mpv
    " play      " mpd mpc_cli ncmpcpp
    " download  " youtube-dl bandcamp-dl
    " tools     " pavucontrol picard

    ### PROGRAMMING
    " c         " gcc manpages gnumake gdb
    " ruby      " ruby pry
    " python2   " ( py python27 [] )
    " python3   " ( py python37 [] )
    " haskell   " ( haskellPackages.ghcWithPackages ( hp: with hp; [ pointfree classy-prelude-yesod yesod-auth yesod-bin persistent-sqlite foreign-store HaskellForMaths ] ) )
    " latex     " ( texlive.combine { inherit (texlive) scheme-small latexmk enumitem collectbox adjustbox pgfplots cancel multirow chemfig simplekv arydshln; } )
    " cmd line  " bc jq sage google-cloud-sdk
    " misc      " perl openjdk rustup julia_11 racket-minimal jelly mathematica j nodejs coq mono

    ### UTILITIES
    " files     " zip unzip p7zip renameutils file stow xdg-user-dirs djvu2pdf xxd pandoc poppler_utils cmark binutils
    " sys info  " htop acpi tlp sysstat psmisc light
    " xorg      " xorg.xmodmap xorg.xkbcomp xdotool xsel
    " internet  " wget w3m transmission lighttpd
    " packaging " patchelf bundix
    " security  " pass gnupg pinentry_ncurses
    " fun       " fortune cowsay espeak bsdgames ttyrec ipbt
    " misc      " rlwrap shell-scripts hplip

  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    ( import ../overlays/custom-pkg.nix "bandcamp-dl" )
    ( import ../overlays/custom-pkg.nix "ipbt" )
    ( import ../overlays/custom-pkg.nix "jelly" )
    ( import ../overlays/custom-pkg.nix "ppi3" )
    ( import ../overlays/custom-pkg.nix "pry" )
    ( import ../overlays/custom-pkg.nix "qxw" )
    ( import ../overlays/custom-pkg.nix "shell-scripts" )
    ( import ../overlays/sudo-0xinsults.nix )
    ( import ../overlays/pidgin.nix ( with pkgs; [ purple-hangouts ] ) )
    ( import ../overlays/jconsole-priority.nix )
  ];

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.zsh.enable = true;
  programs.light.enable = true;
  programs.adb.enable = true;

  programs.slock.enable = true;
  # programs.xss-lock.enable = true;
  # programs.xss-lock.lockerCommand = "${pkgs.slock}/bin/slock";

  services.redshift.enable = true;
  services.redshift.extraOptions = [ "-mdrm" ];
  location.provider = "geoclue2";

  services.tlp.enable = true;
  services.tlp.extraConfig = ''
  TLP_ENABLE=1
  START_CHARGE_THRESH_BAT0=76
  STOP_CHARGE_THRESH_BAT0=80
  START_CHARGE_THRESH_BAT1=76
  STOP_CHARGE_THRESH_BAT1=80
  '';

}
