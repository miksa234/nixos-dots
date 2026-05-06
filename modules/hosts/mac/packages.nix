{ ... }:
{
  dendritic.modules.darwin.host-mac-packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        neovim
        wget
        git
        nix
        curl
        tree
        coreutils
        stdenv
        pciutils
        util-linux
        pstree
        wireguard-tools
      ];

      fonts.packages = with pkgs; [
        nerd-fonts.terminess-ttf
        terminus_font
      ];
    };
}
