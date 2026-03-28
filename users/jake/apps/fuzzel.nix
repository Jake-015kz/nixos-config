{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        terminal = "${pkgs.ghostty}/bin/ghostty";
        prompt = "❯  ";
        layer = "overlay";
        width = 35;
        horizontal-pad = 20;
        vertical-pad = 12;
        inner-pad = 8;
        line-height = 28;
        # Скругляем под стиль Niri (12px)
        border-radius = 12;
      };

      # Цвета в палитре Ayu Dark
      colors = {
        background = "0f1419ff"; # Глубокий темный фон
        text = "e6e1cfff"; # Кремовый текст
        match = "f29718ff"; # Золотистый акцент для совпадений
        selection = "253342ff"; # Выделение (темно-синий)
        selection-text = "ffcc66ff"; # Текст при выделении
        selection-match = "f29718ff";
        border = "59c2ffff"; # Светло-голубая рамка
      };

      border = {
        width = 2;
        radius = 12;
      };
    };
  };
}
