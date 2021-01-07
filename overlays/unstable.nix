self: super: {
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
}
