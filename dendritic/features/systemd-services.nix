{ pkgs, ... }:
{
  systemd.user = {
    startServices = "sd-switch";
    services.mbsync = {
      Unit = {
        Description = "Mailbox sync service";
        RefuseManualStart = "no";
        RefuseManualStop = "yes";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.zsh}/bin/zsh -c 'mbsync -c .config/isync/mbsyncrc -a -q'";
      };
      Install = {
        wantedBy = [ "default.target" ];
      };
    };
    timers.mbsync = {
      Unit = {
        Description = "Mailbox sync timer";
        RefuseManualStop = "no";
        RefuseManualStart = "no";
      };
      Timer = {
        Persistent = false;
        OnBootSec = "0.3m";
        OnUnitActiveSec = "0.5m";
        Unit = "mbsync.service";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
    services.niri-wakeup-monitors = {
      Unit = {
        Description = "Wake up external monitors after resume (niri)";
        After = [
          "suspend.target"
          "hibernate.target"
          "systemd-suspend-then-hibernate.target"
        ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.zsh}/bin/zsh -c 'niri-wakeup-monitors'";
      };

      Install = {
        WantedBy = [
          "suspend.target"
          "hibernate.target"
          "systemd-suspend-then-hibernate.target"
        ];
      };
    };
  };
}
