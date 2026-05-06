{ ... }:
{
  dendritic.data = {
    niriWorkspaces = {
      "l1" = { };
      "l2" = { };
      "l3" = { };
      "l4" = { };
      "l5" = { };
      "r1" = { };
      "r2" = { };
      "r3" = { };
      "r4" = { };
      "r5" = { };
    };

    niriLayout = {
      default-column-width.proportion = 0.5;
      border = {
        enable = true;
        width = 4;
        active.color = "#ffc87f";
        inactive.color = "#263238";
      };
      gaps = 10;
      focus-ring.enable = false;
    };

    niriCursor = {
      size = 16;
      theme = "Adwaita";
    };

    niriInput = {
      focus-follows-mouse.enable = false;
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
      mouse.accel-profile = "flat";
    };
  };
}
