{
  config,
  pkgs,
  lib,
  standalone ? false,
  isDarwin ? pkgs.stdenv.isDarwin,
  ...
}:
let

  packageSets = import ../modules/packages.nix { inherit pkgs isDarwin; };

  link = config.lib.file.mkOutOfStoreSymlink;
  inherit (import ../lib/dotfiles.nix) dotfiles;
  configDirs = builtins.attrNames (builtins.readDir "${dotfiles}/.config");
in
{
  nixpkgs = if standalone
  then {
    config.allowUnfree = true;
  } else
    {};

  home = {
    username = "mika";
    stateVersion = if isDarwin then "25.05" else "25.11";
    packages = lib.flatten (
      with packageSets; [
        system
        shell
        cli
        media
        fileManagement
        network
        office
        fonts
        email
        development
      ]  ++ lib.optionals (!isDarwin) [ xorg ]
    );

    file = {
      ".zshenv".source = link "${dotfiles}/.zshenv";
      ".local" = {
        source = link "${dotfiles}/.local";
        recursive = true;
      };
      ".config/nix-zsh-plugins.zsh".text = ''
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
        source ${pkgs.zsh-system-clipboard}/share/zsh/zsh-system-clipboard/zsh-system-clipboard.zsh
      '';
    } // lib.optionalAttrs (isDarwin) {
      "/Users/mika/Applications" = {
        source = link "/Users/mika/Applications/Home Manager Apps/";
        recursive = true;
      };
    };
  } // lib.optionalAttrs (!isDarwin || standalone){
    homeDirectory = if isDarwin then "/Users/mika" else "/home/mika";
  };

  programs.kitty = lib.mkIf isDarwin {
    enable = true;
    font = {
      name = "Terminess Nerd Font";
      size = 18;
    };
    settings = {
      background_opacity = 0.93;
      confirm_os_window_close = 0;
      touch_scroll_multiplier = 1.0;
    };
  };

  imports =
    [
      ../modules/mbsync_timer.nix
      ../modules/firefox.nix
    ]
    ++ lib.optionals standalone [ ../modules/nix_settings.nix ]
    ++ lib.optionals (!isDarwin) [ ../modules/theme.nix ]
    ++ lib.optionals (!isDarwin && standalone)  [../modules/xdg.nix];

  xdg.configFile = let
    filteredDirs = builtins.filter (dir: dir != "systemd") configDirs;
  in
    lib.genAttrs filteredDirs (dir: {
      source = link "${dotfiles}/.config/${dir}";
      recursive = true;
    });

}


