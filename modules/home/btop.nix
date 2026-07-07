{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.btop ];

  # Catppuccin btop themes (read-only is fine for theme files).
  xdg.configFile = {
    "btop/themes/catppuccin_mocha.theme".source = ../../shared/themes/btop/catppuccin_mocha.theme;
    "btop/themes/catppuccin_latte.theme".source = ../../shared/themes/btop/catppuccin_latte.theme;
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
