self: super: {
  sudo = let
    sudo1 = super.sudo;
    sudo2 = sudo1.override { withInsults = true; };
    sudo3 = sudo2.overrideAttrs (attrs: {
      patches = (if attrs ? patches then attrs.patches else []) ++ [ ./sudo-0xinsults.patch ];
    });
  in sudo3;
}
