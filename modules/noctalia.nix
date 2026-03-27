{ inputs, ... }:
{
  # import the home manager module
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        backgroundOpacity = 0;
        contentPadding = 10;
        enableExclusionZoneInset = false;
        fontScale = 1.1;
        outerCorners = false;
        showCapsule = false;
        useSeparateOpacity = true;
        widgetSpacing = 30;
        widgets = {
          center = [
            {
              hideMode = "hidden";
              maxWidth = 145;
              scrollingMode = "hover";
              showIcon = false;
              textColor = "none";
              useFixedWidth = false;
              id = "ActiveWindow";
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
              fontWeight = "bold";
              groupedBorderOpacity = 1;
              hideUnoccupied = false;
              iconScale = 0.8;
              labelMode = "index";
              occupiedColor = "none";
              pillSize = 0.67;
              showApplications = false;
              showApplicationsHover = false;
              showBadge = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
              id = "Workspace";
            }
          ];
          right = [
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Bluetooth";
              textColor = "none";
            }
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Volume";
              middleClickCommand = "pwvucontrol || pavucontrol";
              textColor = "none";
            }
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Network";
              textColor = "none";
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
              useMonospaceFont = true;
              usePadding = false;
              id = "SystemMonitor";
            }
            {
              clockColor = "none";
              customFont = "";
              formatHorizontal = "HH:mm:ss";
              formatVertical = "HH mm - dd MM";
              id = "Clock";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
            }
          ];
        };
      };
      colorSchemes = {
        predefinedScheme = "Rose Pine";
      };
      dock = {
        enabled = false;
      };
      general = {
        avatarImage = "";
        radiusRatio = 0;
      };
      location = {
        name = "Lisbon";
      };
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
        fontDefault = "Terminess Nerd Font";
        fontDefaultScale = 1.12;
        fontFixed = "Terminess Nerd Font";
      };
      wallpaper = {
        enabled = false;
        useWallhaven = true;
      };
    };
  };
}
