{ config, pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    libertinus
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "DejaVu Serif" ];
      sansSerif = [ "DejaVu Sans" ];
      monospace = [ "DejaVu Sans Mono" ];
    };

    # when a font is not found (or unspecified), fall back to DejaVu Sans
    # needed for firefox, which for some reason doesn't request with a fallback
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig><match>
        <test name="family" qual="all" compare="not_eq"><string>sans-serif</string></test>
        <test name="family" qual="all" compare="not_eq"><string>serif</string></test>
        <test name="family" qual="all" compare="not_eq"><string>monospace</string></test>
        <edit name="family" mode="append_last"><string>DejaVu Sans</string></edit>
      </match></fontconfig>
    '';
  };
}
