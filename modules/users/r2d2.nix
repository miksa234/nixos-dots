{ ... }:
{
  dendritic.modules.home.user-r2d2 =
    {
      pkgs,
      lib,
      dendritic,
      ...
    }:
    let
      packageSets = dendritic.data.packageSets.default {
        inherit pkgs lib;
        isDarwin = false;
      };
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

      home.file.".config/nix-zsh-plugins.zsh".text = ''
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
        source ${pkgs.zsh-system-clipboard}/share/zsh/zsh-system-clipboard/zsh-system-clipboard.zsh
      '';
    };
}
