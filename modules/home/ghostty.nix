{ ... }:
{
  # Ghostty itself is a Homebrew cask (GUI app); this ships its config.
  # One theme (Solitude) regardless of macOS appearance.
  xdg.configFile = {
    "ghostty/config".source = ../../shared/ghostty/config;
    "ghostty/themes/solitude".source = ../../shared/ghostty/themes/solitude;
  };
}
