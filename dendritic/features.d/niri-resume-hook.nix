{ config, pkgs, ... }:

let
  user = "mika";
  uid = toString config.users.users.${user}.uid;

  niriWakeupMonitors = pkgs.writeShellScriptBin "niri-wakeup-monitors" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    mon_n="BOE 0x0BCA Unknown"
    mon_l="PNP(BNQ) BenQ GL2760 H3E04203019"
    mon_r="PNP(BNQ) BenQ GL2760 SCF04101019"

    niri="${pkgs.niri}/bin/niri"
    grep="${pkgs.gnugrep}/bin/grep"
    wc="${pkgs.coreutils}/bin/wc"
    tr="${pkgs.coreutils}/bin/tr"
    seq="${pkgs.coreutils}/bin/seq"

    active_connection() {
      count=$("$niri" msg outputs | "$grep" -E "H3E04203019|SCF04101019" | "$wc" -l | "$tr" -d ' ')
      [ "$count" -eq 2 ]
    }

    move_workspaces() {
      local monitor="$1"
      local direction="$2"

      for nw in $("$seq" 1 9); do
        "$niri" msg action \
          move-workspace-to-monitor \
          --reference "$direction$nw" \
          "$monitor"
      done

      "$niri" msg action focus-monitor "$monitor"

      for nw in $("$seq" 1 9); do
        "$niri" msg action \
          move-workspace-to-index \
          --reference "$direction$nw" \
          "$nw"
      done
    }

    mulmon_activate() {
      "$niri" msg output "$mon_l" on
      "$niri" msg output "$mon_r" on
      move_workspaces "$mon_l" "l"
      move_workspaces "$mon_r" "r"
      "$niri" msg output "$mon_n" off
    }

    mulmon_deactivate() {
      "$niri" msg output "$mon_n" on
      move_workspaces "$mon_n" "r"
      move_workspaces "$mon_n" "l"
      "$niri" msg output "$mon_l" off
      "$niri" msg output "$mon_r" off
    }

    if active_connection; then
      mulmon_activate
    else
      mulmon_deactivate
    fi
  '';
in
{
  environment.systemPackages = [ niriWakeupMonitors ];

  environment.etc."systemd/system-sleep/niri-wakeup-monitors" = {
    mode = "0755";
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      # args: pre|post  suspend|hibernate|hybrid-sleep|suspend-then-hibernate
      if [ "''${1:-}" = "post" ]; then
        exec ${pkgs.util-linux}/bin/runuser -u ${user} -- \
          env XDG_RUNTIME_DIR=/run/user/${uid} \
              DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${uid}/bus \
              ${pkgs.bash}/bin/bash -lc '
                # wait briefly for niri IPC to be ready after resume
                for i in $(seq 1 30); do
                  ${pkgs.niri}/bin/niri msg -q outputs >/dev/null 2>&1 && break
                  sleep 0.2
                done
                ${niriWakeupMonitors}/bin/niri-wakeup-monitors
              '
      fi
    '';
  };
}
