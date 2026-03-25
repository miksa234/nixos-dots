{ inputs, ... }:
{
  inports = [ inputs.niri.homeModules.niri ];
  programs.niri.settings = {
    enable = true;
    prefer-no-csd = false;
    layout = {
      focus-ring = {
        width = 2;
      };
    };
    input = {
      focus-follows-mouse.enable = true;
      keyboard = {
        xkb = {
          layout = "us,de";
          model = "pc104";
          options = "grp:shifts_toggle";
        };
        repeat-rate = 50;
        repeat-delay = 200;
      };
      touchpad = {
        natural-scroll = false;
        tap = true;
      };
      mouse = {
        accel-profile = "flat";
      };
    };
    binds = {
      "Mod+Return".action.spawn = "alacritty";
      "XF86AudioRaiseVolume".action.spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
      "XF86AudioLowerVolume".action.spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
    };
  };
}
