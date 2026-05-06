{
  lib,
  config,
  ...
}:
{
  dendritic.configs.home.mika.modules =
    [
      "nix-settings"
      "user-mika"
      "firefox"
      "alacritty"
      "theme"
      "xdg"
      "systemd-services"
    ]
    ++ lib.optionals config.isWayland [
      "niri"
      "noctalia"
    ];
}
