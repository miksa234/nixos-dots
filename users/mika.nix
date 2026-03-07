{
  config,
  pkgs,
  lib,
  standalone ? false,
  isDarwin ? pkgs.stdenv.isDarwin,
  ...
}:
let

  packageSets = import ../modules/packages.nix { inherit pkgs; };

  link = config.lib.file.mkOutOfStoreSymlink;
  inherit (import ../lib/dotfiles.nix) dotfiles;
  configDirs = builtins.attrNames (builtins.readDir "${dotfiles}/.config");
in
{
  home = {
    username = "mika";
    homeDirectory = if isDarwin then "/Users/mika" else "/home/mika";
    stateVersion = if isDarwin then "25.05" else "25.11";
  };

  programs.kitty = lib.mkIf isDarwin {
    enable = true;
    font = {
      name = "Terminess Nerd Font";
      size = 18;
    };
    settings = {
      confirm_os_window_close = 0;
    };
  };

  imports =
    [
      ../modules/mbsync_timer.nix
      ../modules/firefox.nix
    ]
    ++ lib.optionals standalone [
      ../modules/xdg.nix
      ../modules/nix_settings.nix
    ]
    ++ lib.optional (!isDarwin) [ ../modules/theme.nix ];

  nixpkgs = if standalone
  then {
    config.allowUnfree = true;
  } else
    {};

  home.packages = with packageSets; lib.flatten [
    system
    shell
    cli
    xorg
    media
    fileManagement
    network
    office
    email
    development
  ];

  home.file = {
    ".zshenv".source = link "${dotfiles}/.zshenv";
    ".local" = {
      source = link "${dotfiles}/.local";
      recursive = true;
    };
    ".config/nix-zsh-plugins.zsh".text = ''
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
      source ${pkgs.zsh-system-clipboard}/share/zsh/zsh-system-clipboard/zsh-system-clipboard.zsh
    '';
  };

  xdg.configFile = let
    filteredDirs = builtins.filter (dir: dir != "systemd") configDirs;
  in
    lib.genAttrs filteredDirs (dir: {
      source = link "${dotfiles}/.config/${dir}";
      recursive = true;
    });

}


