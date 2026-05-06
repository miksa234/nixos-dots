{ ... }:
{
  dendritic.modules.nixos.host-frame-desktop =
    { ... }:
    {
      services = {
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
        xserver = {
          enable = true;
          serverFlagsSection = ''
            Option "Xauth" "$XAUTHORITY"
          '';
          displayManager.startx.enable = true;
        };
        getty.autologinUser = "mika";
        logind.settings.Login = {
          SleepOperation = "suspend-then-hibernate";
          HandlePowerKey = "suspend-then-hibernate";
          HandleLidSwitch = "suspend-then-hibernate";
          HandlePowerKeyLongPress = "poweroff";
        };
        gnome.gnome-keyring.enable = true;
      };

      services.libinput = {
        enable = true;
        touchpad.naturalScrolling = false;
      };

      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
}
