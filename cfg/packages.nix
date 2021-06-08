{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  let
    py = v: e: (v.withPackages ( p: with p; [
      requests beautifulsoup4 numpy matplotlib virtualenv pillow #pandas plotly
    ] ++ e )).override ( args: { ignoreCollisions = true; } );
  in
  builtins.filter ( x: builtins.typeOf x != "string" ) [

    ### BASE
    " wm        " i3 i3blocks rofi ppi3
    " terminal  " termite zsh neovim tmux git
    " misc      " dunst libnotify xss-lock slock redshift equilux-theme adwaita-qt

    ### APPLICATIONS
    " browsers  " firefox chromium
    " chat      " tdesktop irssi discord pidgin-with-plugins skype unstable.zoom-us
    " games     " steam steam-run the-powder-toy
    " emulators " fceux dolphinEmu mupen64plus
    " mail      " mutt isync notmuch notmuch-mutt newsboat
    " puzzles   " sgtpuzzles qxw
    " misc      " wine libreoffice anki

    ### MEDIA
    " edit      " gimp inkscape audacity imagemagick ffmpeg musescore lilypond lmms #sunvox
    " capture   " maim slop simplescreenrecorder
    " view      " feh zathura timidity mpv
    " play      " mpd mpc_cli ncmpcpp
    " download  " youtube-dl bandcamp-dl
    " tools     " pavucontrol qjackctl picard optipng adb-sync

    ### PROGRAMMING
    " c         " gcc manpages gnumake gdb
    " ruby      " ( ruby.withPackages ( p : with p; [ nokogiri pry ] ) )
    " python2   " ( py python27 [] )
    " python3   " ( py python38 [ pyrogram ] )
    " haskell   " ghc
                  #( haskellPackages.ghcWithPackages ( hp: with hp; [
                  #  classy-prelude-yesod yesod-auth yesod-bin yesod-websockets persistent-sqlite foreign-store #yesod-auth-oauth2
                  #  warp
                  #  HaskellForMaths data-fix wreq #pointfree
                  #  quantities
                  #  # stm-containers
                  #  # HTF
                  #  hoogle
                  #] ) )
    " java      " openjdk gradle
    " misc      " bc jq perl rustup racket-minimal jelly j nodejs coq mono sqlite-interactive sass gnuplot tectonic #unstable.mathematica #julia_13
    " tools     " universal-ctags google-cloud-sdk

    ### UTILITIES
    " files     " renameutils binutils moreutils file xdg-user-dirs xxd ripgrep fd
    " compress  " zip unzip p7zip
    " documents " djvu2pdf pandoc pdftk poppler_utils cmark
    " sys info  " htop acpi tlp sysstat psmisc light
    " xorg      " xorg.xmodmap xorg.xkbcomp xorg.xev xorg.xwininfo xdotool xsel x11vnc
    " internet  " wget w3m transmission lighttpd iftop
    " packaging " patchelf bundix nix-index
    " security  " pass gnupg pinentry-curses
    " fun       " fortune cowsay espeak bsdgames ipbt figlet #ttyrec
    " misc      " rlwrap shell-scripts

    ### TEMPORARY
    jamulus

  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    # ( import ../overlays/custom-pkg.nix "ipbt" )
    # ( import ../overlays/custom-pkg.nix "jelly" )
    # ( import ../overlays/custom-pkg.nix "pry" )
    # ( import ../overlays/custom-pkg.nix "pygame" )
    # ( import ../overlays/custom-pkg.nix "discordrb" )
    ( import ../overlays/custom-pkg.nix "bandcamp-dl" )
    ( import ../overlays/custom-pkg.nix "ppi3" )
    ( import ../overlays/custom-pkg.nix "pyrogram" )
    ( import ../overlays/custom-pkg.nix "qxw" )
    ( import ../overlays/custom-pkg.nix "shell-scripts" )
    ( import ../overlays/custom-pkg.nix "shemicolon" )
    ( import ../overlays/discord.nix )
    ( import ../overlays/fix-pyflakes.nix )
    ( import ../overlays/jconsole-priority.nix )
    ( import ../overlays/pidgin.nix ( with pkgs; [ purple-hangouts ] ) )
    ( import ../overlays/stm-containers.nix )
    ( import ../overlays/sudo-0xinsults.nix )
    ( import ../overlays/unstable.nix )
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

  programs.slock.enable = true;
  # programs.xss-lock.enable = true;
  # programs.xss-lock.lockerCommand = "${pkgs.slock}/bin/slock";

  services.redshift.enable = true;
  services.redshift.extraOptions = [ "-mdrm" ];
  location.provider = "geoclue2";

  services.tlp.enable = true;
  services.tlp.settings = {
    TLP_ENABLE = 1;
    START_CHARGE_THRESH_BAT0 = 76;
    STOP_CHARGE_THRESH_BAT0  = 80;
    START_CHARGE_THRESH_BAT1 = 76;
    STOP_CHARGE_THRESH_BAT1  = 80;
  };

}
