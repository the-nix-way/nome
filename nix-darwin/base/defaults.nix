{ pkgs }:

{
  CustomUserPreferences."com.apple.desktopservices" = {
    DSDontWriteNetworkStores = true;
    DSDontWriteUSBStores = true;
  };

  dock = {
    autohide = true;
    mru-spaces = false;
    show-recents = false;
    tilesize = 44;
    # Quick Note
    wvous-br-corner = 14;
  };

  finder = {
    AppleShowAllFiles = true;
    FXEnableExtensionChangeWarning = false;
    # Search the current folder
    FXDefaultSearchScope = "SCcf";
    # List view
    FXPreferredViewStyle = "Nlsv";
    _FXSortFoldersFirst = true;
  };

  NSGlobalDomain = {
    # Disable font smoothing (stem darkening) for thinner, crisper text; apps must be relaunched to pick it up
    AppleFontSmoothing = 0;
    AppleInterfaceStyle = "Dark";
    AppleShowAllExtensions = true;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
  };

  # The directory is created by Home Manager; macOS falls back to the Desktop if it's missing
  screencapture.location = "${pkgs.lib.homeDirectory}/Pictures/Screenshots";

  trackpad.TrackpadRightClick = true;
}
