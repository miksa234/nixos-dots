{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    colors = {
      mError = "#ff6b6b";
      mOnError = "#0b0f14";

      mPrimary = "#bababa";
      mOnPrimary = "#ffffff";

      mSecondary = "#6CA98A";
      mOnSecondary = "#ffffff";

      mSurface = "#0b0f14";
      mOnSurface = "#e6edf3";

      mSurfaceVariant = "#111827";
      mOnSurfaceVariant = "#c9d1d9";

      mTertiary = "#ffc87f";
      mOnTertiary = "#07130a";

      mHover = "#1f2937";
      mOnHover = "#e6edf3";

      mOutline = "#30363d";
      mShadow = "#000000";
    };
    settings = {
      bar = {
        backgroundOpacity = 0;
        contentPadding = 10;
        enableExclusionZoneInset = false;
        fontScale = 1.2;
        outerCorners = false;
        showCapsule = false;
        useSeparateOpacity = true;
        widgetSpacing = 30;
        widgets = {
          center = [
            {
              hideMode = "hidden";
              maxWidth = 500;
              scrollingMode = "hover";
              showIcon = false;
              textColor = "none";
              useFixedWidth = false;
              id = "ActiveWindow";
              fontWeight = "bold";
            }
          ];
          left = [
            {
              characterCount = 2;
              colorizeIcons = false;
              emptyColor = "none";
              enableScrollWheel = true;
              focusedColor = "none";
              followFocusedScreen = false;
              groupedBorderOpacity = 1;
              hideUnoccupied = false;
              labelMode = "index";
              occupiedColor = "none";
              pillSize = 0.75;
              showApplications = false;
              showApplicationsHover = false;
              showBadge = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
              id = "Workspace";
              fontWeight = "bold";
            }
          ];
          right = [
            {
              id = "NotificationHistory";
            }
            {
              id = "Battery";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Volume";
            }
            {
              id = "Network";
            }
            {
              compactMode = false;
              diskPath = "/";
              iconColor = "none";
              showCpuCores = false;
              showCpuFreq = false;
              showCpuTemp = true;
              showCpuUsage = true;
              showDiskAvailable = false;
              showDiskUsage = false;
              showDiskUsageAsPercent = false;
              showGpuTemp = false;
              showLoadAverage = false;
              showMemoryAsPercent = false;
              showMemoryUsage = true;
              showNetworkStats = false;
              showSwapUsage = false;
              textColor = "none";
              usePadding = false;
              id = "SystemMonitor";
              fontWeight = "bold";
            }
            {
              formatHorizontal = "HH:mm:ss";
              id = "Clock";
              fontWeight = "bold";
            }
          ];
        };
      };
      dock.enabled = false;
      general = {
        avatarImage = "";
        radiusRatio = 0;
        enableShadows = false;
      };
      location.name = "Lisbon";
      colorSchemes.useWallPaperColors = true;
      sessionMenu = {
        largeButtonsStyle = false;
        powerOptions = [
          {
            command = "";
            countdownEnabled = true;
          }
          {
            command = "";
            countdownEnabled = true;
          }
          {
            command = "";
            countdownEnabled = true;
          }
          {
            command = "";
            countdownEnabled = true;
          }
          {
            command = "";
            countdownEnabled = true;
          }
          {
            command = "";
            countdownEnabled = true;
          }
          {
            command = "";
            countdownEnabled = true;
          }
          {
            action = "userspaceReboot";
            command = "";
            countdownEnabled = true;
            enabled = false;
            keybind = "";
          }
        ];
      };
      ui = {
        fontScale = 1.2;
        fontDefault = "Terminus";
        fontFixed = "Terminus";
      };
      wallpaper = {
        enabled = false;
        useWallhaven = true;
      };
    };
  };
}
