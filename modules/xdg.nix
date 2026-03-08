{pkgs, ...}:
{
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "st";
    FILE_BROWSER = "lf";
    XDG_SESSION_TYPE = "x11";
    XDG_DESKTOP_DIR ="$HOME/desktop";
    XDG_DOWNLOAD_DIR = "$HOME/downloads";
    XDG_PUBLICSHARE_DIR = "$HOME/cloud";
  };
  xdg.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
