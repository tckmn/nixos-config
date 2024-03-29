{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  builtins.filter ( x: builtins.typeOf x != "string" ) [

    ### BASE
    " wm        " i3 i3blocks rofi ppi3
    " terminal  " termite neovim tmux git #zsh
    " misc      " dunst libnotify equilux-theme adwaita-qt #slock xss-lock redshift

    ### APPLICATIONS
    " browsers  " firefox chromium
    " chat      " tdesktop irssi skypeforlinux zoom-us #pidgin discord
    " games     " steam steam-run the-powder-toy
    " emulators " fceux dolphinEmu mupen64plus
    " mail      " mutt isync cyrus_sasl notmuch notmuch-mutt newsboat
    " puzzles   " sgtpuzzles qxw
    " misc      " wine libreoffice anki

    ### MEDIA
    " edit      " gimp inkscape audacity imagemagick ffmpeg musescore lilypond lmms #sunvox
    " capture   " maim slop simplescreenrecorder
    " view      " feh zathura timidity mpv
    " play      " mpd mpc_cli ncmpcpp
    " download  " #youtube-dl bandcamp-dl
    " tools     " pavucontrol picard optipng adb-sync #qjackctl

    ### PROGRAMMING
    " c         " gcc clang gnumake cmake gdb man-pages
    " ruby      " ( ruby.withPackages ( p : with p; [ nokogiri pry ] ) )
    " python2   " ( python27.withPackages ( p : with p; [] ))
    " python3   " ( python38.withPackages ( p : with p; [ requests numpy virtualenv pillow ] ))
    " haskell   " ghc stack
    " java      " openjdk gradle
    " misc      " bc jq perl rustup racket-minimal jelly j nodejs coq mono sqlite-interactive sass gnuplot tectonic agda #unstable.mathematica #julia_13
    " tools     " universal-ctags google-cloud-sdk

    ### UTILITIES
    " files     " renameutils binutils moreutils file xdg-user-dirs xxd ripgrep fd
    " compress  " zip unzip p7zip
    " documents " djvu2pdf pandoc pdftk poppler_utils cmark
    " sys info  " htop acpi sysstat psmisc #light tlp
    " xorg      " xorg.xmodmap xorg.xkbcomp xorg.xev xorg.xwininfo xdotool xsel x11vnc
    " internet  " wget w3m transmission lighttpd iftop
    " packaging " patchelf bundix nix-index
    " security  " pass pinentry-curses oathToolkit #gnupg
    " fun       " fortune cowsay espeak bsdgames ipbt figlet #ttyrec
    " misc      " rlwrap shell-scripts

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
    ( import ../overlays/custom-pkg.nix "shell-scripts" )
    ( import ../overlays/custom-pkg.nix "shemicolon" )
    ( import ../overlays/jconsole-priority.nix )
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
  programs.mosh.enable = true;

  programs.slock.enable = true;
  # programs.xss-lock.enable = true;
  # programs.xss-lock.lockerCommand = "${pkgs.slock}/bin/slock";

  services.redshift.enable = true;
  location.provider = "geoclue2";

}
