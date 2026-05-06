{ isDarwin, ... }:
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
        opacity = 0.99;
      };

      font = {
        normal = {
          family = if isDarwin then "Terminess Nerd Font" else "Terminus";
          style = "Regular";
        };
        italic = {
          family = if isDarwin then "Terminess Nerd Font" else "Terminus";
          style = "Regular";
        };
        bold_italic = {
          family = if isDarwin then "Terminess Nerd Font" else "Terminus";
          style = "Bold";
        };
        size = if isDarwin then 18 else 14;
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
      };

      cursor = {
        style = {
          shape = "Block";
        };
        thickness = 0.2;
      };

      selection = {
        semantic_escape_chars = " ";
      };

      mouse = {
        hide_when_typing = false;
      };

      keyboard.bindings = [
        # Scrollback
        {
          key = "U";
          mods = "Alt";
          action = "ScrollLineUp";
        }
        {
          key = "D";
          mods = "Alt";
          action = "ScrollLineDown";
        }
        {
          key = "U";
          mods = "Alt|Shift";
          action = "ScrollPageUp";
        }
        {
          key = "D";
          mods = "Alt|Shift";
          action = "ScrollPageDown";
        }

        {
          key = "C";
          mods = "Alt";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Alt";
          action = "Paste";
        }
      ];
    };
  };
}
