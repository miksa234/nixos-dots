{
  config,
  pkgs,
  lib,
  inputs,
  isDarwin,
  isWayland,
  ...
}:
let

  packageSets = import ../features.d/packages.nix { inherit pkgs isDarwin; };

  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  nixpkgs = {
    config.allowUnfree = true;
  };

  home = {
    username = "mika";
    stateVersion = if isDarwin then "25.11" else "26.05";
    packages = lib.flatten (
      with packageSets;
      [
        system
        shell
        cli
        media
        fileManagement
        communication
        network
        office
        fonts
        email
        development
      ]
      ++ lib.optionals (!isDarwin && !isWayland) [ xorg ]
      ++ lib.optionals (isWayland) [ wayland ]
    );

    file = {
      ".config/nix-zsh-plugins.zsh".text = ''
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
        source ${pkgs.zsh-system-clipboard}/share/zsh/zsh-system-clipboard/zsh-system-clipboard.zsh
      '';
    };
  }
  // lib.optionalAttrs (!isDarwin) {
    homeDirectory = "/home/mika";
  };

  imports = [
    ../features.d/firefox.nix
    (import ../features.d/alacitty.nix { inherit isDarwin; })
  ]
  ++ lib.optionals (!isDarwin) [
    ../features.d/theme.nix
    ../features.d/xdg.nix
    ../features.d/systemd-services.nix
  ]
  ++ lib.optionals (isWayland) [
    ../features.d/niri.nix
    ../features.d/noctalia.nix
  ];

}
