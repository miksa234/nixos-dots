{
  config,
  pkgs,
  lib,

  ...
}:
let
  packageSets = import ../modules/packages.nix { inherit pkgs; };
  inherit (import ../modules/config-dots.nix) config-dots config-nvim;
in
{
  home = {
    username = "r2d2";
    homeDirectory = "/home/r2d2";
    stateVersion = "25.11";
  };

  home.packages =
    (
      with packageSets;
      lib.flatten [
        system
        shell
        cli
        network
        development
      ]
    )
    ++ [ pkgs.lf ];

  home.file =
    let
      mkDotfileLink = path: {
        source = config.lib.file.mkOutOfStoreSymlink "${config-dots}/${path}";
        recursive = true;
      };
      mkNvimfileLink = path: {
        source = config.lib.file.mkOutOfStoreSymlink "${config-nvim}";
        recursive = true;
        force = true;
      };
    in
    {
      ".zshenv" = mkDotfileLink ".zshenv";
      ".config/zsh/.zshrc" = mkDotfileLink ".config/zsh/.zshrc";
      ".config/shell" = mkDotfileLink ".config/shell";
      ".config/git" = mkDotfileLink ".config/git";
      ".config/nvim" = mkNvimfileLink ".config/nvim";
      ".config/nix-zsh-plugins.zsh".text = ''
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
        source ${pkgs.zsh-system-clipboard}/share/zsh/zsh-system-clipboard/zsh-system-clipboard.zsh
      '';
      ".local" = mkDotfileLink ".local";
    };
}
