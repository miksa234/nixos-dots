{ ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "Terminess Nerd Font";
      size = 18;
    };
    settings = {
      background_opacity = 0.93;
      confirm_os_window_close = 0;
      touch_scroll_multiplier = 1.0;
    };
  };
}
