{ ... }:
{
  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "st-256color";

      window = {
        padding = {
          x = 2;
          y = 2;
        };
        opacity = 0.96;
      };

      font = {
        normal = {
          family = "Terminus";
          style = "Regular";
        };
        italic = {
          family = "Terminus";
          style = "Regular";
        };
        bold_italic = {
          family = "Terminus";
          style = "Bold";
        };
        size = 12;
      };

      colors = {
        primary = {
          background = "#000000";
          foreground = "#EEEEEE";
        };

        cursor = {
          text = "#000000";
          cursor = "#EEEEEE";
        };

        normal = {
          black = "#000000";
          red = "#ed0b0b";
          green = "#40a62f";
          yellow = "#f2e635";
          blue = "#327bd1";
          magenta = "#b30ad0";
          cyan = "#3975b8";
          white = "#EEEEEE";
        };

        bright = {
          black = "#262626";
          red = "#b55454";
          green = "#78a670";
          yellow = "#faf380";
          blue = "#68a7d4";
          magenta = "#c583d0";
          cyan = "#3975b8";
          white = "#EEEEEE";
        };
      };

      bell = {
        duration = 0;
      }; # st bellvolume=0 (closest match)

      cursor = {
        style = {
          shape = "Block";
        };
        thickness = 0.2; # st cursorthickness=2px; approximate (Alacritty uses fraction)
      };

      selection = {
        semantic_escape_chars = " ";
      };

      mouse = {
        hide_when_typing = false;
      };
    };
  };
}
