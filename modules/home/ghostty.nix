{ ... }:
{
  # Ghostty itself is a Homebrew cask (GUI app); this ships its config.
  # Unlike Terminal.app it follows macOS appearance natively via
  # `theme = light:...,dark:...`, so theme-sync doesn't touch it.
  xdg.configFile = {
    "ghostty/config".source = ../../shared/ghostty/config;
    "ghostty/themes/claude-dark".source = ../../shared/ghostty/themes/claude-dark;
    "ghostty/themes/claude-light".source = ../../shared/ghostty/themes/claude-light;
  };
}
