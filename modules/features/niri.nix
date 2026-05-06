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
        hotkey-overlay.skip-at-startup = true;
        overview = {
          backdrop-color = "#000000";
        };

        window-rules = [
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

        workspaces = {
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
        binds =
          let
            nshic = "noctalia-shell ipc call";
          in
          {
            "Mod+Return".action.spawn = "${terminalCmd}";
            "Mod+C".action.spawn = "firefox";
            "Mod+D".action.spawn = "dmenu-niri_run";
            "Mod+P".action.spawn = "passmenu-otp";
            "Mod+B".action.spawn = "dmenu-bluetooth";
            "Mod+Alt+L".action.spawn = "swaylock -f -c 000000";
            "Mod+W".action.spawn = "spotify";
            "Mod+Shift+P".action.spawn = "pavucontrol";
            "Mod+Shift+B".action.spawn = "nautilus";
            "Mod+Shift+W".action.spawn-sh = "${terminalCmd} -e nmtui";
            "Mod+M".action.spawn-sh = "TZ=Europe/Berlin ${terminalCmd} -e neomutt";
            "Mod+Shift+R".action.spawn-sh = "background";
            "Mod+Shift+Slash".action.show-hotkey-overlay = { };
            "Mod+Ctrl+Space".action.spawn-sh = "${nshic} notifications removeOldestHistory";
            "Ctrl+Space".action.spawn-sh = "${nshic} notifications dismissOldest";
            "Mod+Space".action.spawn-sh = "${nshic} notifications toggleHistory";

            "Mod+Shift+E".action.quit.skip-confirmation = true;
            "Mod+Shift+Q".action.close-window = { };
            "Mod+F".action.maximize-column = { };
            "Mod+G".action.fullscreen-window = { };
            "Mod+Shift+F".action.toggle-window-floating = { };
            "Mod+Shift+C".action.center-column = { };

            "Mod+K".action.focus-column-right = { };
            "Mod+J".action.focus-column-left = { };
            "Alt+K".action.focus-workspace-up = { };
            "Alt+J".action.focus-workspace-down = { };

            "Mod+H".action.focus-monitor-left = { };
            "Mod+L".action.focus-monitor-right = { };

            "Mod+Ctrl+WheelScrollDown".action.focus-column-left = { };
            "Mod+Ctrl+WheelScrollUp".action.focus-column-right = { };
            "Mod+WheelScrollDown".action.focus-workspace-down = { };
            "Mod+WheelScrollUp".action.focus-workspace-up = { };

            "Mod+Shift+K".action.move-column-right = { };
            "Mod+Shift+J".action.move-column-left = { };
            "Alt+Shift+K".action.move-window-to-workspace-up = { };
            "Alt+Shift+J".action.move-window-to-workspace-down = { };

            "Mod+Shift+H".action.move-window-to-monitor-left = { };
            "Mod+Shift+L".action.move-window-to-monitor-right = { };
            "Mod+Tab".action.toggle-overview = { };

            "Mod+1".action.focus-workspace = "l1";
            "Mod+2".action.focus-workspace = "l2";
            "Mod+3".action.focus-workspace = "l3";
            "Mod+4".action.focus-workspace = "l4";
            "Mod+5".action.focus-workspace = "l5";
            "Mod+6".action.focus-workspace = "l6";
            "Mod+7".action.focus-workspace = "l7";
            "Mod+8".action.focus-workspace = "l8";
            "Mod+9".action.focus-workspace = "l9";

            "Alt+1".action.focus-workspace = "r1";
            "Alt+2".action.focus-workspace = "r2";
            "Alt+3".action.focus-workspace = "r3";
            "Alt+4".action.focus-workspace = "r4";
            "Alt+5".action.focus-workspace = "r5";
            "Alt+6".action.focus-workspace = "r6";
            "Alt+7".action.focus-workspace = "r7";
            "Alt+8".action.focus-workspace = "r8";
            "Alt+9".action.focus-workspace = "r9";

            "Mod+Shift+1".action.move-window-to-workspace = "l1";
            "Mod+Shift+2".action.move-window-to-workspace = "l2";
            "Mod+Shift+3".action.move-window-to-workspace = "l3";
            "Mod+Shift+4".action.move-window-to-workspace = "l4";
            "Mod+Shift+5".action.move-window-to-workspace = "l5";
            "Mod+Shift+6".action.move-window-to-workspace = "l6";
            "Mod+Shift+7".action.move-window-to-workspace = "l7";
            "Mod+Shift+8".action.move-window-to-workspace = "l8";
            "Mod+Shift+9".action.move-window-to-workspace = "l9";

            "Alt+Shift+1".action.move-window-to-workspace = "r1";
            "Alt+Shift+2".action.move-window-to-workspace = "r2";
            "Alt+Shift+3".action.move-window-to-workspace = "r3";
            "Alt+Shift+4".action.move-window-to-workspace = "r4";
            "Alt+Shift+5".action.move-window-to-workspace = "r5";
            "Alt+Shift+6".action.move-window-to-workspace = "r6";
            "Alt+Shift+7".action.move-window-to-workspace = "r7";
            "Alt+Shift+8".action.move-window-to-workspace = "r8";
            "Alt+Shift+9".action.move-window-to-workspace = "r9";

            "Mod+F1".action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "Mod+F2".action.spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
            "Mod+F3".action.spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "Mod+F4".action.spawn-sh = "${nshic} brightness decrease";
            "Mod+F5".action.spawn-sh = "${nshic} brightness increase";

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
          default-column-width.proportion = 0.5;
          border = {
            enable = true;
            width = 4;
            active = {
              color = "#ffc87f";
            };
            inactive = {
              color = "#263238";
            };
          };
          gaps = 10;
          focus-ring = {
            enable = false;
          };
        };
        cursor = {
          size = 16;
          theme = "Adwaita";
        };

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        spawn-at-startup = [
          { command = [ "noctalia-shell" ]; }
          { command = [ "background" ]; }
          #          { command = [ "dunst" ]; }
          { command = [ "check-mail" ]; }
          {
            command = [
              "dbus-update-activation-environment"
              "--systemd DISPLAY XDG_CURRENT_DESKOP=niri"
            ];
          }
          {
            command = [
              "systemctl"
              " --user"
              "import-environment DISPLAY XDG_CURRENT_DESKTOP=niri"
            ];
          }
          {
            command = [
              "niri-monitors"
            ];
          }
          {
            command = [
              "nextcloud"
              "--background"
            ];
          }
          {
            command = [
              "${lib.getExe pkgs.swayidle}"
              "-w"
              "timeout"
              "300"
              "swaylock -f -c 000000"
#              "timeout"
#              "900"
#              "systemctl suspend-then-hibernate"
#              "before-sleep"
#              "swaylock -f -c 000000"
            ];
          }
        ];

        outputs = {
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
          "BOE 0x0BCA Unknown" = {
            enable = true;
            mode = {
              width = 2256;
              height = 1504;
            };
            position = {
              x = 3840;
              y = 0;
            };
          };
        };
        input = {
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
          mouse = {
            accel-profile = "flat";
          };
        };
      };
  };
}
