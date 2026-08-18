{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.btop ];

  # Bluloco Dark/Light btop themes (read-only is fine for theme files).
  xdg.configFile = {
    "btop/themes/bluloco_dark.theme".source = ../../shared/themes/btop/bluloco_dark.theme;
    "btop/themes/bluloco_light.theme".source = ../../shared/themes/btop/bluloco_light.theme;
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
