{ config
, pkgs
, inputs
, lib
, ...
}:

{
  imports = [
    ./hardware.nix
    ../../modules/system/core.nix
    ../../modules/system/user.nix # Добавлен
    ../../modules/system/network.nix # Добавлен
    ../../modules/apps/internet.nix
    ../../modules/apps/media.nix
    ../../modules/apps/dev.nix
    ../../modules/apps/cli-tools.nix
    ../../modules/system/performance.nix
    ../../modules/desktop/niri
    ../../modules/services/acestream.nix
    ../../modules/apps/fish.nix
  ];

  # --- ВКЛЮЧАЕМ НАШИ МОДУЛИ ---
  jake.system.user.enable = true;
  jake.system.network = {
    enable = true;
    hostName = "jake-pc";
  };
  jake.desktop.niri.enable = true;
  # --- ЯДРО (Параметры для ASUS TUF / AMD остаются здесь, так как это специфика железа) ---
  boot.kernelParams = [
    "amdgpu.backlight=0"
    "acpi_backlight=vendor"
    "video.use_native_backlight=1"
    "amd_pstate=active"
    "quiet"
  ];

  # --- СЕРВИСЫ ХОСТА (Пока оставляем, вынесем на следующих этапах) ---
  services.fwupd.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.tumbler.enable = true;
  services.lact.enable = true;
  services.ollama.enable = true;
  virtualisation.docker.enable = true;

  # --- ИНТЕРФЕЙС (Вынесем позже в дисплейный модуль) ---
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "jake";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "niri";
  };

  # --- ПАКЕТЫ ХОСТА (Оставляем только системный минимум) ---
  environment.systemPackages = with pkgs; [
    wget
    brightnessctl
    wl-clipboard
    fastfetch
    nh
    pciutils
    usbutils
    duf
    lsof
    ltrace
  ];

  # --- HOME MANAGER ---
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    users.jake = {
      imports = [ ../../users/jake/home.nix ];
    };
  };

  system.stateVersion = "25.11";
}
