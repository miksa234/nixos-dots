{ ... }:
{
  dendritic.data.noctaliaWidgets = {
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
      { id = "NotificationHistory"; }
      { id = "Battery"; }
      { id = "Bluetooth"; }
      { id = "Volume"; }
      { id = "Network"; }
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
}
