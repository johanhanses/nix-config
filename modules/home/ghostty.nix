{ ... }:
{
  # Ghostty itself is a Homebrew cask (GUI app); this ships its config.
  # Unlike Terminal.app it follows macOS appearance natively via
  # `theme = light:...,dark:...`, so theme-sync doesn't touch it.
  xdg.configFile = {
    "ghostty/config".source = ../../shared/ghostty/config;
    "ghostty/themes/bluloco-dark".source = ../../shared/ghostty/themes/bluloco-dark;
    "ghostty/themes/bluloco-light".source = ../../shared/ghostty/themes/bluloco-light;
  };
}
