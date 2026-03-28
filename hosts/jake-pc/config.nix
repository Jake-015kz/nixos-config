{ config
, pkgs
, inputs
, ...
}:

{
  imports = [
    ./hardware.nix
    ../../modules/desktop/kde.nix
    ../../modules/apps/internet.nix
    ../../modules/apps/media.nix
    ../../modules/apps/dev.nix
    ../../modules/apps/cli-tools.nix
  ];

  # --- ПОДКЛЮЧЕНИЕ HOME MANAGER ---
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    users.jake = import ../../users/jake/home.nix;
  };

  # Обязательно для корректной работы Fish как дефолтной оболочки
  programs.fish.enable = true;

  # --- ПОЛЬЗОВАТЕЛЬ И АВТОЛОГИН ---
  users.users.jake = {
    isNormalUser = true;
    description = "Jake";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "input"
      "docker"
    ];
    shell = pkgs.fish;
  };

  # Настройка автологина в SDDM (KDE)
  services.displayManager.autoLogin = {
    enable = true;
    user = "jake";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # --- СИСТЕМА И ЛОКАЛЬ ---
  time.timeZone = "Asia/Almaty";
  i18n.defaultLocale = "ru_RU.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "ru";
  };

  # --- NIX SETTINGS (Очистка и Оптимизация) ---
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true; # Твое предложение по оптимизации
      substituters = [
        "https://cache.nixos.org"
        "https://nyx.chaotic.cx"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "chaotic-nyx.cachix.org-1:9nsqcneyu6tosew79mrephcdsmvjkscgluydaeiuww0="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d"; # Твое предложение по очистке
    };
  };

  chaotic.nyx.cache.enable = true;

  # --- ЯДРО И ЖЕЛЕЗО ---
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  boot.kernelParams = [
    "amdgpu.backlight=0"
    "acpi_backlight=vendor"
    "video.use_native_backlight=1"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking.hostName = "jake-pc";
  networking.networkmanager.enable = true;

  # --- СЕРВИСЫ ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Настройка клавиатуры
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };

  zramSwap.enable = true;

  # --- СИСТЕМНЫЕ ПАКЕТЫ ---
  environment.systemPackages = with pkgs; [
    wget
    brightnessctl
    wl-clipboard
    fastfetch
    nh
  ];

  environment.sessionVariables = {
    NH_FLAKE = "/home/jake/.dotfiles";
  };

  # --- NIX-LD (для запуска бинарников не из nixpkgs) ---
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  system.stateVersion = "25.11";
}
