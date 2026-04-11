{ config, pkgs, ... }:

let
  user = "mika";
  uid = toString config.users.users.${user}.uid;
in
{
  environment.etc."systemd/system-sleep/niri-wakeup-monitors" = {
    mode = "0755";
    text = ''
      #!${pkgs.bash}/bin/bash
      # args: pre|post  suspend|hibernate|hybrid-sleep|suspend-then-hibernate
      if [ "$1" = "post" ]; then
        # run in the user session context so niri IPC works
        exec ${pkgs.util-linux}/bin/runuser -u ${user} -- \
          env XDG_RUNTIME_DIR=/run/user/${uid} \
              DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${uid}/bus \
              niri-wakeup-monitors
      fi
    '';
  };
}
