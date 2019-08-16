pkg: self: super: builtins.listToAttrs [
  { name = pkg; value = super.callPackage (../pkgs + ("/" + pkg)) {}; }
]
