{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.btop ];

  # Solitude btop theme (read-only is fine for theme files).
  xdg.configFile."btop/themes/solitude.theme".source = ../../shared/themes/btop/solitude.theme;

  # btop.conf must stay mutable (btop writes its own settings back, and
  # theme-sync rewrites color_theme) — install it once if absent, not as a
  # read-only Nix symlink.
  home.activation.btopConf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    conf="$HOME/.config/btop/btop.conf"
    if [ ! -e "$conf" ]; then
      run mkdir -p "$HOME/.config/btop"
      run cp ${../../shared/btop/btop.conf} "$conf"
      run chmod u+w "$conf"
    fi
  '';
}
