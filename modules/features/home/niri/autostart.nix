{ ... }:
{
  dendritic.data.niriAutostart =
    { lib, pkgs }:
    [
      { command = [ "noctalia-shell" ]; }
      { command = [ "background" ]; }
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
        ];
      }
    ];
}
