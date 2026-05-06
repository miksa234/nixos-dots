{ ... }:
{
  dendritic.data.niriRules = [
    {
      matches = [ { app-id = "spotify"; } ];
      open-on-workspace = "l5";
      open-maximized = true;
    }
    {
      matches = [ { app-id = "Alacritty"; } ];
      opacity = 0.96;
    }
    {
      matches = [ { app-id = "firefox"; } ];
      open-maximized = true;
    }
    {
      matches = [ { app-id = "telegram"; } ];
      open-maximized = true;
    }
  ];
}
