{ pkgs , ... }:
{
  systemd.user = {
    services.mbsync = {
      unit = {
        Description = "Mailbox sync service";
        RefuseManualStart = "no";
        RefuseManualStop = "yes";
      };
      service = {
        Type = "oneshot";
        ExecStart = "${pkgs.zsh}/bin/zsh -c '${pkgs.isync}/bin/mbsync -c %h/.config/isync/mbsyncrc -a -q'";
        StandardOutput = "syslog";
        StandardError = "syslog";
      };
      install = {
        wantedBy = [ "mbsync.timer" ];
      };
    };
    timers.mbsync = {
      Unit = {
        Description = "Mailbox synchronization timer";
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
        WantedBy = [ "default.target" ];
      };
    };
  };
}
