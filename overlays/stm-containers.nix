nself: nsuper: {
  haskellPackages = nsuper.haskellPackages.override {
    overrides = self: super: {
      HTF = nself.haskell.lib.dontCheck (self.callHackage "HTF" "0.13.2.5" {});
      stm-hamt = self.callHackage "stm-hamt" "1.2.0.3" {};
      stm-containers = nself.haskell.lib.markUnbroken super.stm-containers;
    };
  };
}
