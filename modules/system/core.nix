{ config, pkgs, ... }:

{
  # Сжатие памяти (Zram)
  zramSwap.enable = true;

  # Настройка X11 и консоли (работает и для Wayland в KDE)
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle"; # Переключение через Alt+Shift
  };

  # Чтобы в консоли (TTY) тоже был русский язык
  i18n.defaultLocale = "ru_RU.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "ru"; # По умолчанию в консоли будет ru, либо us
  };

  # Шрифты
  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    
    # Новый синтаксис для Nerd Fonts (v25.05+)
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only    # Для иконок в Waybar/KDE
  ];

  # Звук Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Авто-очистка системы от мусора
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}