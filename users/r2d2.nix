{
  config,
  pkgs,
  lib,

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
    username = "r2d2";
    homeDirectory = "/home/r2d2";
    stateVersion = "25.11";
  };


  home.packages = (with packageSets; lib.flatten [
    system
    shell
    cli
    network
    development
  ]) ++ [ pkgs.lf ];


  home.file = let
    mkDotfileLink = path: {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
      recursive = true;
    };
  in {
    ".zshenv" = mkDotfileLink ".zshenv";
    ".config/zsh/.zshrc" = mkDotfileLink ".config/zsh/.zshrc";
    ".config/shell" = mkDotfileLink ".config/shell";
    ".config/git" = mkDotfileLink ".config/git";
    ".config/nvim" = mkDotfileLink ".config/nvim";
    ".config/nix-zsh-plugins.zsh".text = ''
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
      source ${pkgs.zsh-system-clipboard}/share/zsh/zsh-system-clipboard/zsh-system-clipboard.zsh
    '';
    ".local" = mkDotfileLink ".local";
  };
}


