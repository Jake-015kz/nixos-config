{ pkgs, inputs, ... }: { 
  # Включаем сам композитор
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    # Главная звезда шоу — тянем напрямую из флейка
    inputs.noctalia.packages.${pkgs.system}.default
    
    # Системные утилиты для Wayland/Niri
    xwayland
    wl-clipboard
    brightnessctl
    wireplumber
    
    # Вспомогательный софт для интерфейса
    fuzzel      # Меню запуска (Mod+D)
    swaybg      # Обои (нужен для spawn-at-startup "swaybg")
    libnotify   # Уведомления
    waybar      # Оставляем как запасной вариант, если Noctalia закапризничает
  ];

  # --- СЕРВИСЫ ДЛЯ NOCTALIA (БЕЗ НИХ ПАНЕЛЬ БУДЕТ ПУСТОЙ ИЛИ ВЫЛЕТИТ) ---
  services.upower.enable = true;                # Индикатор батареи
  services.power-profiles-daemon.enable = true; # Управление питанием (Performance/Eco)
  security.polkit.enable = true;                # Чтобы панель могла запрашивать пароли
  hardware.bluetooth.enable = true;             # Для виджета блютуза в панели
  services.gvfs.enable = true;                  # Чтобы в панели отображались флешки/диски
}