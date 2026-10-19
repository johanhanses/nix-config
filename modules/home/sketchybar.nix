{ lib, ... }:
{
  # SketchyBar config (the agent itself is services.sketchybar in
  # modules/darwin/bar.nix). Shipped wholesale; plugins must stay executable.
  xdg.configFile."sketchybar" = {
    source = ../../shared/sketchybar;
    recursive = true;
  };

  # Pick up config edits on switch. (A bar started before its config existed
  # can't reload — it only resolves the config path at launch; restart it with
  # `launchctl kickstart -k gui/$UID/org.nixos.sketchybar` in that case.)
  home.activation.sketchybarReload = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if /usr/bin/pgrep -x sketchybar >/dev/null 2>&1; then
      run /run/current-system/sw/bin/sketchybar --reload || true
    fi
  '';
}
