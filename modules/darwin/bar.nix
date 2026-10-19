{ pkgs, ... }:
{
  # SketchyBar — custom top bar replacing the (auto-hidden) native menu bar.
  # Config is raw shell under shared/sketchybar, shipped to ~/.config/sketchybar
  # by modules/home/sketchybar.nix; with `config` empty the agent reads it from
  # there. Colours follow macOS appearance via colors.sh + theme-sync.
  services.sketchybar = {
    enable = true;
    extraPackages = [ pkgs.jq ];
  };

  # JankyBorders — accent border around the focused window. These are only the
  # startup values (One Dark accent); theme-sync re-colours the running
  # instance on every appearance change (theme-watch also runs it at login).
  services.jankyborders = {
    enable = true;
    active_color = "0xff61afef";
    inactive_color = "0x00000000";
    width = 5.0;
    style = "round";
    hidpi = true;
  };
}
