{ config, ... }:
{
  # SwiftBar (cask in homebrew.nix) runs every executable in its plugin folder.
  # Point it at the repo dir out-of-store, like theme.nix does for scripts, so
  # plugin edits apply without a rebuild. Plugins: shared/swiftbar/.
  targets.darwin.defaults."com.ameba.SwiftBar" = {
    PluginDirectory = "${config.home.homeDirectory}/Repos/github.com/johanhanses/nix-config/shared/swiftbar";
    SUHasLaunchedBefore = true;
  };
}
