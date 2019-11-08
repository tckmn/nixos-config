plist: self: super: {
  pidgin-with-plugins = super.pidgin-with-plugins.override { plugins = plist; };
}
