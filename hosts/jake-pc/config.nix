{ config
, pkgs
, inputs
, ...
}:

{
  imports = [
    ./hardware.nix
    ../../modules/system/core.nix
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
      "libvirtd"
    ];
    shell = pkgs.fish;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "jake";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # --- NIX SETTINGS ---
  nixpkgs.config.allowUnfree = true;

  chaotic.nyx.cache.enable = true;

  # --- ЯДРО И ЖЕЛЕЗО (Твики для ASUS TUF) ---
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  boot.kernelParams = [
    "amdgpu.backlight=0"
    "acpi_backlight=vendor"
    "video.use_native_backlight=1"
    "amd_pstate=active" # Улучшенное управление питанием для Ryzen 5 3550H
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Bluetooth (часто забывают включить)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl

    ]; # Ускорение видео
  };

  networking.hostName = "jake-pc";
  networking.networkmanager.enable = true;

  # Поддержка Docker (ты в группе docker, но сервис нужно включить)
  virtualisation.docker.enable = true;

  # --- СИСТЕМНЫЕ ПАКЕТЫ ---
  environment.systemPackages = with pkgs; [
    wget
    brightnessctl
    wl-clipboard
    fastfetch
    nh
    pciutils
    usbutils # Системные утилиты
    lm_sensors # Для мониторинга температуры твоего TUF
  ];

  environment.sessionVariables = {
    NH_FLAKE = "/home/jake/.dotfiles";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
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
