{ ... }:
{
  dendritic.modules.nixos.host-frame-services =
    { ... }:
    {
      services = {
        automatic-timezoned.enable = false;
        avahi = {
          enable = true;
          nssmdns4 = true;
          publish = {
            enable = true;
            userServices = true;
          };
        };
        gvfs.enable = true;
        udisks2.enable = true;
        upower.enable = true;
        fwupd.enable = true;
        openssh.enable = true;
        tlp.enable = false;
        power-profiles-daemon.enable = true;
      };
    };
}
