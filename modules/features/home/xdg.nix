{ ... }:
{
  dendritic.modules.home.xdg =
    { pkgs, lib, isDarwin, ... }:
    lib.mkIf (!isDarwin) {
      home.sessionVariables = {
        EDITOR = "nvim";
        BROWSER = "firefox";
        TERMINAL = "st";
        FILE_BROWSER = "lf";
        XDG_SESSION_TYPE = "x11";
        XDG_DESKTOP_DIR = "$HOME/desktop";
        XDG_DOWNLOAD_DIR = "$HOME/downloads";
        XDG_PUBLICSHARE_DIR = "$HOME/cloud";
      };
      xdg.enable = true;

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/magnet" = "torrent.desktop";
          "application/x-bittorrent" = "torrent.desktop";
          "x-scheme-handler/mailto" = "mail.desktop";
          "message/rfc822" = "mail.desktop";
          "application/pdf" = "pdf.desktop";
          "text/calendar" = "cal.desktop";
          "image/png" = "img.desktop";
          "image/jpeg" = "img.desktop";
          "image/jpg" = "img.desktop";
          "image/bmp" = "img.desktop";
          "image/webp" = "img.desktop";
          "image/svg+xml" = "img.desktop";
          "image/gif" = "gif.desktop";
          "text/plain" = "text.desktop";
          "text/x-readme" = "text.desktop";
        };
      };

      xdg.portal = {
        enable = true;
        config.common.default = "*";
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-wlr
        ];
      };
    };
}
