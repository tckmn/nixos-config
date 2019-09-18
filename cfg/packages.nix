{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  let py = v: e: v.withPackages ( p: with p; [ requests ] ++ e ); in
  builtins.filter ( x: builtins.typeOf x != "string" ) [

    ### BASE
    " wm        " i3 i3blocks rofi
    " terminal  " termite zsh neovim tmux git
    " misc      " dunst libnotify xss-lock slock redshift equilux-theme

    ### APPLICATIONS
    " internet  " firefox chromium tdesktop irssi
    " games     " steam the-powder-toy
    " mail      " mutt isync notmuch notmuch-mutt newsboat
    " puzzles   " sgtpuzzles qxw
    " misc      " wine

    ### MEDIA
    " edit      " gimp inkscape audacity imagemagick ffmpeg musescore
    " capture   " maim slop simplescreenrecorder
    " view      " feh zathura timidity mpv
    " play      " mpd mpc_cli ncmpcpp
    " tools     " pavucontrol picard

    ### PROGRAMMING LANGUAGES
    " ruby      " ruby pry
    " python2   " ( py python27 [] )
    " python3   " ( py python37 [] )
    " latex     " ( texlive.combine { inherit (texlive) scheme-small latexmk enumitem collectbox adjustbox pgfplots cancel multirow chemfig simplekv; } )
    " misc      " perl jdk ghc rustup julia racket-minimal jq bc sage jelly

    ### UTILITIES
    " files     " zip unzip renameutils file stow xdg-user-dirs djvu2pdf
    " sys info  " htop acpi tlp sysstat psmisc light
    " xorg      " xorg.xmodmap xdotool xsel
    " internet  " wget w3m youtube-dl transmission
    " packaging " patchelf bundix
    " security  " pass gnupg pinentry_ncurses
    " fun       " fortune cowsay espeak
    " misc      " rlwrap xxd

  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    ( import ../overlays/custom-pkg.nix "jelly" )
    ( import ../overlays/custom-pkg.nix "pry" )
    ( import ../overlays/custom-pkg.nix "qxw" )
    ( import ../overlays/sudo-0xinsults.nix )
  ];

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.zsh.enable = true;
  programs.slock.enable = true;
  programs.light.enable = true;
}
