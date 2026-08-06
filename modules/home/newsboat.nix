{ pkgs, ... }:
{
  home.packages = [ pkgs.newsboat ];

  # Config + feed list carried over from dotfiles2026. Colors use `default`/
  # `reverse` so newsboat inherits the terminal's ANSI palette and follows the
  # Ghostty light/dark toggle for free — no theme-sync hook needed.
  # ~/.newsboat does not exist, so newsboat reads the XDG paths below.
  xdg.configFile = {
    "newsboat/config".source = ../../shared/newsboat/config;
    "newsboat/urls".source = ../../shared/newsboat/urls;
  };
}
