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

      mPrimary = "#A96C8A";
      mOnPrimary = "#ffffff";

      mSecondary = "#6CA98A";
      mOnSecondary = "#ffffff";

      mSurface = "#0b0f14";
      mOnSurface = "#e6edf3";

      mSurfaceVariant = "#111827";
      mOnSurfaceVariant = "#c9d1d9";

      mTertiary = "#c583d0";
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
              focusedColor = "primary";
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
              displayMode = "onhover";
              iconColor = "none";
              id = "Bluetooth";
              textColor = "none";
              fontWeight = "bold";
            }
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Volume";
              middleClickCommand = "pwvucontrol || pavucontrol";
              textColor = "none";
              fontWeight = "bold";
            }
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Network";
              textColor = "none";
              fontWeight = "bold";
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
              clockColor = "none";
              formatHorizontal = "HH:mm:ss";
              formatVertical = "HH mm - dd MM";
              id = "Clock";
              tooltipFormat = "HH:mm ddd, MMM dd";
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
