{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.unstable.ghostty;
    settings = {
      theme = "TokyoNight Night";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 13;

      # --- ОТСТУПЫ (Padding) ---
      window-padding-x = 15;
      window-padding-y = 15;
      window-padding-balance = true;

      # --- ВНЕШНИЙ ВИД ---
      background-opacity = 0.85;
      background-blur-radius = 20;
      window-decoration = false;

    };
  };
}
