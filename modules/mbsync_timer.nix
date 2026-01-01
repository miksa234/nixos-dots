{ pkgs , ... }:
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
        ExecStart = "${pkgs.isync}/bin/mbsync -c %h/.config/isync/mbsyncrc -a -q";
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
  };
}
