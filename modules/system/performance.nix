{ pkgs, ... }:

{

  services.power-profiles-daemon.enable = false;
  # Автоматическое управление питанием (важно для ASUS TUF)
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "always";
    };
    battery = {
      governor = "powersave";
      turbo = "never";
    };
  };

  # Поддержка SSD
  services.fstrim.enable = true;

  # Оптимизация прерываний
  services.irqbalance.enable = true;

  environment.systemPackages = with pkgs; [
    gdu # Быстрая замена ncdu
    fastfetch
    lact # Панель управления AMD GPU
    duf # Он у тебя в cli-tools, но можно и тут оставить
  ];
}
