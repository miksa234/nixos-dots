{
  config,
  pkgs,
  lib,
  inputs,
  standalone ? false,
  isDarwin ? pkgs.stdenv.isDarwin,
  isWayland,
  ...
}:
let

  packageSets = import ../modules/packages.nix { inherit pkgs isDarwin; };

  link = config.lib.file.mkOutOfStoreSymlink;
  inherit (import ../modules/config-dots.nix) config-dots config-nvim;
  configDirs = builtins.attrNames (builtins.readDir "${config-dots}/.config");
in
{
  nixpkgs =
    if standalone then
      {
        config.allowUnfree = true;
        overlays = [ inputs.niri.overlays.niri ];
      }
    else
      { };

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
      ".zshenv" = {
        source = link "${config-dots}/.zshenv";
        force = true;
      };
      ".local" = {
        source = link "${config-dots}/.local";
        recursive = true;
        force = true;
      };
      ".config/nvim" = {
        source = link "${config-nvim}";
        recursive = true;
        force = true;
      };
      ".config/nix-zsh-plugins.zsh".text = ''
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
        source ${pkgs.zsh-system-clipboard}/share/zsh/zsh-system-clipboard/zsh-system-clipboard.zsh
      '';
    };
  }
  // lib.optionalAttrs (!isDarwin || standalone) {
    homeDirectory = if isDarwin then "/Users/mika" else "/home/mika";
  };

  imports = [
    ../modules/firefox.nix
    (import ../modules/alacitty.nix { inherit isDarwin; })
  ]
  ++ lib.optionals (!isDarwin) [
    ../modules/theme.nix
    ../modules/xdg.nix
    ../modules/systemd-services.nix
  ]
  ++ lib.optionals (isWayland) [
    ../modules/niri.nix
    ../modules/noctalia.nix
  ]
  ++ lib.optionals (standalone) [
    ../modules/nix-settings.nix
  ];

  xdg.configFile =
    let
      filteredDirs = builtins.filter (dir: dir != "systemd") configDirs;
    in
    lib.genAttrs filteredDirs (dir: {
      source = link "${config-dots}/.config/${dir}";
      recursive = true;
      force = true;
    });

}
