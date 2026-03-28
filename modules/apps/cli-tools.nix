{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Инструменты из твоего списка
    glow
    navi
    gping
    pv
    bat

    # Полезные дополнения
    btop # Красивый мониторинг ресурсов и температур
    lm_sensors # Сами сенсоры
    eza # Современный ls
    fd # Быстрый поиск файлов
    hyperfine # Бенчмаркинг (был в списке)
    tldr # Лаконичные справки
  ];
}
