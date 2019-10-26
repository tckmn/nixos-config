{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  let py = v: e: v.withPackages ( p: with p; [ requests beautifulsoup4 ] ++ e ); in
  builtins.filter ( x: builtins.typeOf x != "string" ) [

    ### BASE
    " wm        " i3 i3blocks rofi ppi3
    " terminal  " termite zsh neovim tmux git
    " misc      " dunst libnotify xss-lock slock redshift equilux-theme

    ### APPLICATIONS
    " internet  " firefox chromium tdesktop irssi discord
    " games     " steam the-powder-toy
    " mail      " mutt isync notmuch notmuch-mutt newsboat
    " puzzles   " sgtpuzzles qxw
    " misc      " wine libreoffice

    ### MEDIA
    " edit      " gimp inkscape audacity imagemagick ffmpeg musescore
    " capture   " maim slop simplescreenrecorder
    " view      " feh zathura timidity mpv
    " play      " mpd mpc_cli ncmpcpp
    " download  " youtube-dl bandcamp-dl
    " tools     " pavucontrol picard

    ### PROGRAMMING
    " c         " gcc manpages
    " ruby      " ruby pry
    " python2   " ( py python27 [] )
    " python3   " ( py python37 [] )
    " haskell   " ( haskellPackages.ghcWithPackages ( hp: with hp; [ pointfree classy-prelude-yesod yesod-auth yesod-bin persistent-sqlite foreign-store HaskellForMaths ] ) )
    " latex     " ( texlive.combine { inherit (texlive) scheme-small latexmk enumitem collectbox adjustbox pgfplots cancel multirow chemfig simplekv; } )
    " cmd line  " bc jq sage google-cloud-sdk
    " misc      " perl jdk rustup julia_11 racket-minimal jelly mathematica

    ### UTILITIES
    " files     " zip unzip p7zip renameutils file stow xdg-user-dirs djvu2pdf xxd pandoc
    " sys info  " htop acpi tlp sysstat psmisc light
    " xorg      " xorg.xmodmap xdotool xsel
    " internet  " wget w3m transmission
    " packaging " patchelf bundix
    " security  " pass gnupg pinentry_ncurses
    " fun       " fortune cowsay espeak bsdgames ttyrec ipbt
    " misc      " rlwrap shell-scripts

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
  ];

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.zsh.enable = true;
  programs.slock.enable = true;
  programs.light.enable = true;
  programs.adb.enable = true;

  services.redshift.enable = true;
  services.redshift.extraOptions = [ "-mdrm" ];
  systemd.user.services.redshift.wantedBy = [ "basic.target" ];
  systemd.user.services.redshift.partOf   = [ "basic.target" ];
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
