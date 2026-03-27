{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings =
      let
        terminalCmd = lib.getExe pkgs.alacritty;
      in
      {
        prefer-no-csd = true;

        window-rules = [
          {
            matches = [ { app-id = "spotify"; } ];
            open-on-workspace = "9";
          }
          {
            matches = [ { app-id = "Alacritty"; } ];
            opacity = 0.9;
          }
        ];
        binds = {
          "Mod+Return".action.spawn = "${terminalCmd}";
          "Mod+C".action.spawn = "firefox";
          "Mod+D".action.spawn = "dmenu-wl_run";
          "Mod+P".action.spawn = "passmenu-otp";
          "Mod+B".action.spawn = "dmenu-bluetooth";
          "Mod+Alt+S".action.spawn = "swaylock";
          "Mod+W".action.spawn = "spotify";
          "Mod+Shift+P".action.spawn = "pavucontrol";
          "Mod+Shift+B".action.spawn = "nautilus";
          "Mod+Shift+W".action.spawn-sh = "${terminalCmd} -e nmtui";
          "Mod+M".action.spawn-sh = "TZ=Europe/Berlin ${terminalCmd} -e neomutt";
          "Mod+Shift+R".action.spawn-sh = "background";

          "Mod+Shift+E".action.quit.skip-confirmation = true;
          "Mod+Shift+Q".action.close-window = { };
          "Mod+G".action.maximize-column = { };
          "Mod+F".action.fullscreen-window = { };
          "Mod+Shift+F".action.toggle-window-floating = { };
          "Mod+Shift+C".action.center-column = { };

          "Mod+K".action.focus-column-right = { };
          "Mod+J".action.focus-column-left = { };
          "Alt+K".action.focus-workspace-up = { };
          "Alt+J".action.focus-workspace-down = { };

          "Mod+H".action.focus-monitor-left = { };
          "Mod+L".action.focus-monitor-right = { };

          "Mod+WheelScrollDown".action.focus-column-left = { };
          "Mod+WheelScrollUp".action.focus-column-right = { };
          "Mod+Ctrl+WheelScrollDown".action.focus-workspace-down = { };
          "Mod+Ctrl+WheelScrollUp".action.focus-workspace-up = { };

          "Mod+Shift+K".action.move-column-right = { };
          "Mod+Shift+J".action.move-column-left = { };
          "Alt+Shift+K".action.move-window-to-workspace-up = { };
          "Alt+Shift+J".action.move-window-to-workspace-down = { };

          "Mod+Shift+H".action.move-window-to-monitor-left = { };
          "Mod+Shift+L".action.move-window-to-monitor-right = { };

          "Mod+1".action.focus-workspace = "1";
          "Mod+2".action.focus-workspace = "2";
          "Mod+3".action.focus-workspace = "3";
          "Mod+4".action.focus-workspace = "4";
          "Mod+5".action.focus-workspace = "5";
          "Mod+6".action.focus-workspace = "6";
          "Mod+7".action.focus-workspace = "7";
          "Mod+8".action.focus-workspace = "8";
          "Mod+9".action.focus-workspace = "9";

          "Mod+Shift+1".action.move-window-to-workspace = "1";
          "Mod+Shift+2".action.move-window-to-workspace = "2";
          "Mod+Shift+3".action.move-window-to-workspace = "3";
          "Mod+Shift+4".action.move-window-to-workspace = "4";
          "Mod+Shift+5".action.move-window-to-workspace = "5";
          "Mod+Shift+6".action.move-window-to-workspace = "6";
          "Mod+Shift+7".action.move-window-to-workspace = "7";
          "Mod+Shift+8".action.move-window-to-workspace = "8";
          "Mod+Shift+9".action.move-window-to-workspace = "9";

          "Mod+F2".action.spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
          "Mod+F3".action.spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          "Mod+F4".action.spawn-sh = "sudo xbacklight -dec 1";
          "Mod+F5".action.spawn-sh = "sudo xbacklight -inc 1";

          "Mod+Ctrl+H".action.set-column-width = "-5%";
          "Mod+Ctrl+L".action.set-column-width = "+5%";
          "Mod+Ctrl+K".action.set-window-height = "-5%";
          "Mod+Ctrl+J".action.set-window-height = "+5%";

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
        cursor = {
          size = 16;
          theme = "Adwaita";
        };

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
          { command = [ "noctalia-shell" ]; }
          { command = [ "background" ]; }
          { command = [ "mako" ]; }
          #{ command = [ "niri-monitors" ]; }
          { command = [ "nextcloud --background" ]; }
        ];

        outputs = {
          "BOE 0x0BCA Unknown".enable = false;
          "PNP(BNQ) BenQ GL2760 H3E04203019" = {
            enable = true;
            scale = 1;
            mode = {
              width = 1920;
              height = 1080;
            };
            position = {
              x = 0;
              y = 0;
            };
          };
          "PNP(BNQ) BenQ GL2760 SCF04101019" = {
            enable = true;
            scale = 1;
            mode = {
              width = 1920;
              height = 1080;
            };
            position = {
              x = 1920;
              y = 0;
            };
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
      };
  };
}
