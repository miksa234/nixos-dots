{ ... }:
{
  dendritic.configs.nixos.server.modules = [
    "hardware-server"
    "host-server"
    "nix-settings"
    "user-mika"
    "root"
  ];
}
