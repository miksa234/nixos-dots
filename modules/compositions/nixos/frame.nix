{ ... }:
{
  dendritic.configs.nixos.frame.modules = [
    "hardware-frame"
    "host-frame-base"
    "host-frame-services"
    "host-frame-desktop"
    "host-frame-packages"
    "nix-settings"
    "user-mika"
    "root"
    "networkmanager"
    "niri-resume-hook"
  ];
}
