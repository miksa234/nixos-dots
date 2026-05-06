{ ... }:
{
  dendritic.modules.darwin.host-mac-defaults =
    { ... }:
    {
      system.defaults = {
        controlcenter = {
          BatteryShowPercentage = true;
          NowPlaying = false;
        };
        CustomUserPreferences = {
          "com.apple.symbolichotkeys" = {
            "64".enabled = false;
            "65".enabled = false;
            "238" = {
              enabled = true;
              value = {
                parameters = [
                  99
                  8
                  1310720
                ];
                type = "standard";
              };
            };
            "98" = {
              enabled = false;
              value = {
                parameters = [
                  47
                  44
                  1179648
                ];
                type = "standard";
              };
            };
          };
        };
        NSGlobalDomain = {
          "com.apple.sound.beep.volume" = 0.000;
          AppleInterfaceStyleSwitchesAutomatically = true;
          ApplePressAndHoldEnabled = false;
          AppleShowAllExtensions = true;
          AppleMetricUnits = 1;
          InitialKeyRepeat = 20;
          KeyRepeat = 2;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          NSAutomaticWindowAnimationsEnabled = false;
          NSDocumentSaveNewDocumentsToCloud = false;
          NSNavPanelExpandedStateForSaveMode = true;
          PMPrintingExpandedStateForPrint = true;
        };
        trackpad = {
          TrackpadRightClick = true;
          TrackpadThreeFingerDrag = true;
          Clicking = true;
        };
        finder = {
          AppleShowAllFiles = true;
          CreateDesktop = false;
          FXDefaultSearchScope = "SCcf";
          FXEnableExtensionChangeWarning = false;
          FXPreferredViewStyle = "Nlsv";
          QuitMenuItem = true;
          ShowPathbar = true;
          ShowStatusBar = true;
          _FXShowPosixPathInTitle = true;
          _FXSortFoldersFirst = true;
        };
        dock = {
          autohide = true;
          expose-animation-duration = 0.15;
          show-recents = false;
          showhidden = true;
          persistent-apps = [ ];
          tilesize = 50;
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
        };
      };

      system.keyboard = {
        enableKeyMapping = true;
        swapLeftCtrlAndFn = true;
        nonUS.remapTilde = true;
        userKeyMapping = [
          {
            HIDKeyboardModifierMappingSrc = 30064771172;
            HIDKeyboardModifierMappingDst = 30064771125;
          }
        ];
      };
    };
}
