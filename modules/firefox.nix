{ inputs, isDarwin, ... }:
{
  imports = [ inputs.betterfox.homeModules.betterfox ];

  programs.firefox = {
    enable = true;
    betterfox = {
      enable = true;
      profiles.frame = {
        settings = {
          fastfox.enable = true;
          peskyfox.enable = true;
        };
      };
      profiles.mulmon = {
        settings = {
          fastfox.enable = true;
          peskyfox.enable = true;
        };
      };
    };
    profiles = {
      frame = {
        id = 0;
        name = "frame";
        isDefault = true;
        settings = {
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.download.start_downloads_in_tmp_dir" = false;
          "browser.download.lastDir" = if isDarwin then "/User/mika" else "/home/mika";
        };
      };
      mulmon = {
        id = 1;
        name = "mulmon";
        isDefault = false;
        settings = {
          "layout.css.devPixelsPerPx" = 0.9;
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.download.useDownloadDir" = true;
          "browser.download.start_downloads_in_tmp_dir" = false;
          "browser.download.lastDir" = if isDarwin then "/User/mika" else "/home/mika";
        };
      };
    };
  };
}

