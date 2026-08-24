{ ... }:
{
  # Ghostty itself is a Homebrew cask (GUI app); this ships its config.
  # Unlike Terminal.app it follows macOS appearance natively via
  # `theme = light:...,dark:...`, so theme-sync doesn't touch it.
  xdg.configFile = {
    "ghostty/config".source = ../../shared/ghostty/config;
    "ghostty/themes/tokyonight-storm".source = ../../shared/ghostty/themes/tokyonight-storm;
    "ghostty/themes/tokyonight-day".source = ../../shared/ghostty/themes/tokyonight-day;
  };
}
