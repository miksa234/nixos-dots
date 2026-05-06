{ ... }:
{
  dendritic.modules.nixos.host-frame-packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vim
        git
        wget
        htop
        git-crypt
        gnupg
        pass
        coreutils
        util-linux
        nix
        curl
        tree
        stdenv
        dbus-broker
        pciutils
        pstree
        wireguard-tools
        gnome.gvfs
        ntfs3g
        upower
        lm_sensors
        acpilight
        ripgrep
        fd
        bat
        alacritty
        firefox
      ];

      fonts.packages = with pkgs; [
        nerd-fonts.terminess-ttf
        noto-fonts
        noto-fonts-color-emoji
        terminus_font
        liberation_ttf
        fira-code
        fira-code-symbols
        ubuntu-classic
        corefonts
      ];
      fonts.fontconfig.useEmbeddedBitmaps = true;
    };
}
