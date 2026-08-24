{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.btop ];

  # Tokyo Night Storm/Day btop themes (read-only is fine for theme files).
  xdg.configFile = {
    "btop/themes/tokyonight_storm.theme".source = ../../shared/themes/btop/tokyonight_storm.theme;
    "btop/themes/tokyonight_day.theme".source = ../../shared/themes/btop/tokyonight_day.theme;
  };

  # btop.conf must stay mutable so theme-sync can rewrite color_theme on the
  # light/dark toggle — install it once if absent (not a read-only Nix symlink).
  home.activation.btopConf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    conf="$HOME/.config/btop/btop.conf"
    if [ ! -e "$conf" ]; then
      run mkdir -p "$HOME/.config/btop"
      run cp ${../../shared/btop/btop.conf} "$conf"
      run chmod u+w "$conf"
    fi
  '';
}
