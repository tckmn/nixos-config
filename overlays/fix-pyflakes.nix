self: super: rec {
  python39 = super.python39.override {
    packageOverrides = self: super: {
      pyflakes = super.pyflakes.overridePythonAttrs (old: {
        doCheck = false;
      });
    };
  };
  python39Packages = python39.pkgs;
}
