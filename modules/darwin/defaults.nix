{ ... }:
{
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
      mru-spaces = false;
    };

    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      FXPreferredViewStyle = "Nlsv"; # list view
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
      ApplePressAndHoldEnabled = false; # hold a key to repeat, not the accent popup
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      # Auto-hide scroll bars (hides Terminal's scrollbar until scrolling). App-wide.
      AppleShowScrollBars = "WhenScrolling";
      "com.apple.mouse.tapBehavior" = 1; # tap to click
    };

    trackpad.Clicking = true;

    screencapture = {
      location = "/Users/johanhanses/Pictures/Screenshots";
      type = "png";
      disable-shadow = true;
    };

    LaunchServices.LSQuarantine = false; # no "are you sure you want to open" nag
  };

  # Remap Caps Lock -> Control.
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
}
