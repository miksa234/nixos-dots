{
  pkgs,
  lib,
  isDarwin ? false,
  ...
}: let
    inherit ( import ../lib/dotfiles.nix ) dotfiles;
in {
  environment.pathsToLink = if (!isDarwin)
    then [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ] else [];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.root = { pkgs, config, ... }: {

      home = {
        username = "root";
        stateVersion = if isDarwin then "25.05" else "25.11";
        file = let
          mkDotfileLink = path: {
            source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
            recursive = true;
          };
        in {
          # zsh no plugins
          ".zshenv" = mkDotfileLink ".zshenv";
          ".config/zsh/.zshrc" = mkDotfileLink ".config/zsh/.zshrc";
          ".config/shell/bindings" = mkDotfileLink ".config/shell/bindings";
          ".config/shell/profile" = mkDotfileLink ".config/shell/profile";
          ".config/shell/aliases" = mkDotfileLink ".config/shell/aliases";
          ".config/git" = mkDotfileLink ".config/git";

          ".local/bin/.keep".text = "";

          # nvim no plugins
          ".config/nvim/init.lua" = mkDotfileLink ".config/nvim/init.lua";
          ".config/nvim/after" = mkDotfileLink ".config/nvim/after";
          ".config/nvim/lua/config" = mkDotfileLink ".config/nvim/lua/config";
        };
      } // lib.optionalAttrs (!isDarwin) {
        homeDirectory = "/root";
      };
    };
  };
}
