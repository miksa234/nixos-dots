{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings =
      let
        noctaliaPkg = inputs.noctalia.packages.${pkgs.system}.default;
        noctaliaExe = lib.getExe noctaliaPkg;
      in
      {
        prefer-no-csd = true;
        binds = {
          "Mod+Return".action.spawn = "alacritty";
          "Mod+C".action.spawn = "firefox";

          "Mod+Shift+E".action.quit.skip-confirmation = true;
          "Mod+Shift+Q".action.close-window = { };
          "Mod+G".action.maximize-column = { };
          "Mod+F".action.fullscreen-window = { };
          "Mod+Shift+F".action.toggle-window-floating = { };
          "Mod+Shift+C".action.center-column = { };

          "Mod+H".action.focus-column-left = { };
          "Mod+L".action.focus-column-right = { };
          "Mod+K".action.focus-window-up = { };
          "Mod+J".action.focus-window-down = { };

          "Mod+WheelScrollDown".action.focus-column-left = { };
          "Mod+WheelScrollUp".action.focus-column-right = { };
          "Mod+Ctrl+WheelScrollDown".action.focus-workspace-down = { };
          "Mod+Ctrl+WheelScrollUp".action.focus-workspace-up = { };

          "Mod+Shift+H".action.move-column-left = { };
          "Mod+Shift+L".action.move-column-right = { };
          "Mod+Shift+K".action.move-window-up = { };
          "Mod+Shift+J".action.move-window-down = { };

          "Mod+1".action.focus-workspace = "1";
          "Mod+2".action.focus-workspace = "2";
          "Mod+3".action.focus-workspace = "3";
          "Mod+4".action.focus-workspace = "4";
          "Mod+5".action.focus-workspace = "5";
          "Mod+6".action.focus-workspace = "6";
          "Mod+7".action.focus-workspace = "7";
          "Mod+8".action.focus-workspace = "8";
          "Mod+9".action.focus-workspace = "9";

          "Mod+Shift+1".action.move-column-to-workspace = "1";
          "Mod+Shift+2".action.move-column-to-workspace = "2";
          "Mod+Shift+3".action.move-column-to-workspace = "3";
          "Mod+Shift+4".action.move-column-to-workspace = "4";
          "Mod+Shift+5".action.move-column-to-workspace = "5";
          "Mod+Shift+6".action.move-column-to-workspace = "6";
          "Mod+Shift+7".action.move-column-to-workspace = "7";
          "Mod+Shift+8".action.move-column-to-workspace = "8";
          "Mod+Shift+9".action.move-column-to-workspace = "9";

          "Mod+F2".action.spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
          "Mod+F3".action.spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";

          "Mod+Ctrl+H".action.set-column-width = "-5%";
          "Mod+Ctrl+L".action.set-column-width = "+5%";
          "Mod+Ctrl+J".action.set-window-height = "-5%";
          "Mod+Ctrl+K".action.set-window-height = "+5%";

          "Shift+Alt+C".action.spawn-sh = "${lib.getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy";

          "Shift+Alt+V".action.spawn-sh =
            "${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -";

          "Shift+Alt+S".action.spawn-sh = lib.getExe (
            pkgs.writeShellApplication {
              name = "screenshot";
              text = ''
                ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -w 0)" - \
                | ${pkgs.wl-clipboard}/bin/wl-copy
              '';
            }
          );
        };
        layout = {
          border = {
            enable = true;
            width = 4;
            active = {
              color = "#A96C8A";
            };
            inactive = {
              color = "#263238";
            };
          };
          gaps = 15;
          focus-ring = {
            enable = false;
          };
        };
        cursor.size = 16;

        workspaces = {
          "1" = { };
          "2" = { };
          "3" = { };
          "4" = { };
          "5" = { };
          "6" = { };
          "7" = { };
          "8" = { };
          "9" = { };
        };

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        spawn-at-startup = [
          { command = [ "${noctaliaExe}" ]; }
          {
            command = [
              "${lib.getExe pkgs.swaybg}"
              "-i"
              "${config.home.homeDirectory}/.local/share/wallpaper/TahoeNight.png"
              "-m"
              "fill"
            ];
          }
        ];

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
      };
  };
}
