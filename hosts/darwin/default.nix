{ config, pkgs, ... }:
let 
  user = "skjoedt";
  modifiers = {
    none = 0;
    option = 524288;
    control = 262144;
    shift = 131072;
    cmd = 1048576;
    "option+cmd" = 1573864;
  };

in
{
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
  ];
  
  # Setup user, packages, programs
  nix = {
    enable = false;
    package = pkgs.nix;
    settings = {
      trusted-users = [ "@admin" "${user}" ];
    };
    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system = {
    # Turn off NIX_PATH warnings now that we're using flakes
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 4;
    defaults = {
      LaunchServices = {
        # Disable the "Are you sure you want to open this application?" dialog
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;

        # Disable automatic substitutions as it's annoying when typing code
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        # Set a blazingly fast keyboard repeat rate
        KeyRepeat = 2;
        InitialKeyRepeat = 25;

        # Trackpad: enable tap to click for this user and for the login screen
        #"com.apple.mouse.tapBehavior" = 1;
        
        # Speed
        "com.apple.trackpad.scaling" = 0.875;

        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;

        # Trackpad: map bottom right corner to right-click
        #"com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        #"com.apple.trackpad.enableSecondaryClick" = true;

        # Save to disk (not to iCloud) by default
        NSDocumentSaveNewDocumentsToCloud = false;

        # Disable "natural" (Lion-style) scrolling
        "com.apple.swipescrolldirection" = true;

        # Finder: Enable spring loading for directories
        "com.apple.springing.enabled" = true;
        "com.apple.springing.delay" = 0.0;
      };

      CustomUserPreferences = {
       # See Symbolic IDs here https://gist.github.com/mattrighetti/24b02c00c8a3a53966bc04f7305f99aa
       # See ASCII mapping here https://gist.github.com/jimratliff/227088cc936065598bedfd91c360334e
       "com.apple.symbolichotkeys" = {
         AppleSymbolicHotKeys = {
           # Disable 'Command + Space' for Spotlight Search
           "64" = {
             enabled = false;
           };
           # Disable 'Command + Option + Space' for Finder search window
           "65" = {
             enabled = false;
           };
           
           # Space hotkeys
           # Switch to Space 1 - Control + 1
           "118" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 18
                 modifiers.control
               ];
               type = "standard";
             };
           };
           # Switch to Space 2 - Control + 2
           "119" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 19
                 modifiers.control
               ];
               type = "standard";
             };
           };
           # Switch to Space 3 - Control + 3
           "120" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 20
                 modifiers.control
               ];
               type = "standard";
             };
           };
           # Switch to Space 4 - Control + 4
           "121" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 21
                 modifiers.control
               ];
               type = "standard";
             };
           };
           # Switch to Space 5 - Control + 5
           "122" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 23
                 modifiers.control
               ];
               type = "standard";
             };
           };
           # Switch to Space 6 - Control + 6
           "123" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 22
                 modifiers.control
               ];
               type = "standard";
             };
           };
           # Switch to Space 7 - Control + 7
           "124" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 26
                 modifiers.control
               ];
               type = "standard";
             };
           };
           # Switch to Space 8 - Control + 8
           "125" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 28
                 modifiers.control
               ];
               type = "standard";
             };
           };
           
           # Disable key 175
           "175" = {
             enabled = false;
           };
           
           # Disable 'Command + Option + D' (Turn Dock Hiding On/Off)
           "52" = {
             enabled = false;
           };

           # Space navigation
           # Move to the space on the left - Control + Left Arrow
           "79" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 123
                 8650752
               ];
               type = "standard";
             };
           };
           # Move to the space on the left with window - Control + Shift + Left Arrow
           "80" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 123
                 8781824
               ];
               type = "standard";
             };
           };
           # Move to the space on the right - Control + Right Arrow
           "81" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 124
                 8650752
               ];
               type = "standard";
             };
           };
           # Move to the space on the right with window - Control + Shift + Right Arrow
           "82" = {
             enabled = 1;
             value = {
               parameters = [
                 65535
                 124
                 8781824
               ];
               type = "standard";
             };
           };
         };
       };
      };

      CustomSystemPreferences = {
        # Trackpad: map bottom right corner to right-click - continued
        #"apple.driver.AppleBluetoothMultitouch.trackpad".TrackpadCornerSecondaryClick = 2;
        #"com.apple.driver.AppleBluetoothMultitouch.trackpad".TrackpadRightClick = true;

        # Use scroll gesture with the Ctrl (^) modifier key to zoom
        "com.apple.universalaccess" = {
          closeViewScrollWheelToggle = true;
          HIDScrollZoomModifierMask = modifiers.control;
          closeViewZoomFollowsFocus = true;
        };

        # Avoid creating .DS_Store files on network or USB volumes
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.systempreferences" = {
          # Disable Resume system-wide
          NSQuitAlwaysKeepsWindows = false;
        };
      };

      
      finder = {
        # Show icons for hard drives, servers, and removable media on the desktop
        ShowExternalHardDrivesOnDesktop = false;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowRemovableMediaOnDesktop = false;

        # Finder: show hidden files by default
        AppleShowAllFiles = true;

        # Show statusbar, pathbar
        ShowStatusBar = true;
        ShowPathbar = true;

        # Keep folders on top when sorting by name
        _FXSortFoldersFirst = true;

        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";

        # Disable the warning when changing a file extension 
        FXEnableExtensionChangeWarning = false;

        # Use list view in all Finder windows by default
        FXPreferredViewStyle = "Nlsv";

        # Do not show path in title 
        _FXShowPosixPathInTitle = false;
      };

      screencapture.type = "png"; # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
      
      dock = {
        autohide = true;
        show-recents = false; # Don't show recent applications in Dock
        mouse-over-hilite-stack = true;
        orientation = "bottom";
        tilesize = 48; # Icon size
        mineffect = "scale"; # Change minimize/maximize window effect
        minimize-to-application = true; # Minimize windows into their application's icon
        enable-spring-load-actions-on-all-items = true; # Enable spring loading for all Dock items
        show-process-indicators = true; # Show indicator lights for open applications in the Dock
        launchanim = false; # Don't animate opening applications from the Dock
        expose-animation-duration = 0.1; # Speed up Mission Control animations
        expose-group-apps = false; # Don't group windows by application in Mission Control (i.e. use the old Exposé behavior instead)
        dashboard-in-overlay = true; # Don't show Dashboard as a Space
        mru-spaces = false; # Don't automatically rearrange Spaces based on most recent use
        autohide-delay = 0.0; # Remove the auto-hiding Dock delay
        autohide-time-modifier = 0.0;
        showhidden = true; # Make Dock icons of hidden applications translucent

        # Hot corners
        # Possible values:
        #  1: Disabled
        #  2: Mission Control
        #  3: Show application windows
        #  4: Desktop
        #  5: Start screen saver
        #  6: Disable screen saver
        #  7: Dashboard
        # 10: Put display to sleep
        # 11: Launchpad
        # 12: Notification Center
        # 13: Lock Screen
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };

      spaces.spans-displays = true;

      #trackpad = {
      #  Clicking = true;
      #  TrackpadThreeFingerDrag = true;
      #};

    };
    #keyboard = {
    #  enableKeyMapping = true;
    #};
  };
}

