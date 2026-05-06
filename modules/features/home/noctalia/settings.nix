{ ... }:
{
  dendritic.data.noctaliaSettings = {
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
        { command = ""; countdownEnabled = true; }
        { command = ""; countdownEnabled = true; }
        { command = ""; countdownEnabled = true; }
        { command = ""; countdownEnabled = true; }
        { command = ""; countdownEnabled = true; }
        { command = ""; countdownEnabled = true; }
        { command = ""; countdownEnabled = true; }
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
}
