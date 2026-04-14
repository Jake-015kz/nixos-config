{ config
, pkgs
, lib
, ...
}:

{
  # --- УПРАВЛЕНИЕ ЭНЕРГОПОТРЕБЛЕНИЕМ ---

  # Отключаем auto-cpufreq, так как он конфликтует с ручным переключением профилей.
  services.auto-cpufreq.enable = false;

  # Включаем стандартный демон профилей мощности.
  # Именно он позволяет использовать команды `powerprofilesctl` (твои алиасы p-bal, p-perf).
  # lib.mkForce true нужен, чтобы перебить возможные выключения в других конфигах.
  services.power-profiles-daemon.enable = lib.mkForce true;

  # Поддержка специфичных функций ASUS (подсветка, лимит зарядки).
  # Даже если CLI (asusctl) капризничает, демон asusd нужен для работы драйверов.
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # Демон для гибридной графики (переключение между встроенной и дискретной AMD).
  services.supergfxd.enable = true;

  # Режим GameMode (оптимизирует планировщик задач процессора для игр или тяжелых билдов).
  programs.gamemode.enable = true;

  # --- ОПТИМИЗАЦИЯ ЯДРА (SYSCTL) ---
  boot.kernel.sysctl = {
    # Сетевые оптимизации (BBR ускоряет работу интернета при потерях пакетов)
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";

    # Улучшение отзывчивости системы
    "vm.vfs_cache_pressure" = 50; # Заставляет ядро дольше держать кэш файлов в памяти
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_slow_start_after_idle" = 0;

    # Специфичные настройки для CachyOS/Gaming
    "kernel.sched_autogroup_enabled" = 0;
    "vm.swappiness" = 10; # Меньше трогаем диск, больше используем RAM/Zram
  };

  # --- ПАМЯТЬ И ЖЕЛЕЗО ---

  # Твой спаситель при 8ГБ оперативы. Сжимает данные в RAM вместо записи на медленный диск.
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # Лучший алгоритм для Ryzen
    memoryPercent = 100; # Позволяет сжимать объем данных, эквивалентный всей твоей RAM
  };

  services.fstrim.enable = true; # Продлевает жизнь SSD
  services.irqbalance.enable = true; # Распределяет нагрузку прерываний по ядрам CPU

  # Настройка видеокарт AMD
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Нужно для Steam и некоторых старых библиотек
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
      rocmPackages.clr.icd # Поддержка OpenCL для ускорения вычислений
    ];
  };

  # --- ПАКЕТЫ И ПЕРЕМЕННЫЕ ---
  environment.systemPackages = with pkgs; [
    lact # Графический интерфейс для настройки видеокарт AMD
    power-profiles-daemon # Утилита для твоих новых алиасов (вместо asusctl profile)
    asusctl # Оставляем для контроля подсветки клавиатуры
    nvtopPackages.amd # Шикарный монитор загрузки видеокарты в терминале
    gdu # Быстрый анализатор занятого места на диске
    lm_sensors # Чтение температур всех датчиков
  ];

  environment.variables = {
    # Принудительно используем открытый драйвер RADV (лучше для игр и Wayland)
    AMD_VULKAN_ICD = "RADV";
  };
}
