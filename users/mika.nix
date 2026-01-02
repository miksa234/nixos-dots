{
  config,
  pkgs,
  lib,
  standalone,

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
    homeDirectory = "/home/mika";
    stateVersion = "25.11";
  };

  imports = if standalone
    then
      [
        ../modules/xdg.nix
        ../modules/nix_settings.nix
        ../modules/mbsync_timer.nix
        ../modules/theme.nix
        ../modules/firefox.nix
      ]
    else
      [
        ../modules/mbsync_timer.nix
        ../modules/theme.nix
        ../modules/firefox.nix
      ];

  nixpkgs.config.allowUnfree = true;
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

  xdg.configFile = lib.genAttrs configDirs (dir: {
    source = link "${dotfiles}/.config/${dir}";
    recursive = true;
  });

}


