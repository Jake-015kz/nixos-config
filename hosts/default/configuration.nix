{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/kde.nix     
    ../../modules/apps/internet.nix
    ../../modules/apps/media.nix
    ../../modules/apps/dev.nix
    ../../modules/apps/cli-tools.nix
  ];

  # --- ПОЛЬЗОВАТЕЛЬ ---
  users.users.jake = {
    isNormalUser = true;
    description = "Jake";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
    shell = pkgs.fish;
  };

  # --- FISH SHELL ---
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
    shellAliases = {
      v = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/#jake-pc";
      ff = "fastfetch";
    };
  };

  # --- СИСТЕМА И ЛОКАЛЬ (РУССКИЙ) ---
  time.timeZone = "Asia/Almaty";
  i18n.defaultLocale = "ru_RU.UTF-8";
  
  console = {
    font = "Lat2-Terminus16";
    keyMap = "ru";
  };

  # --- NIX SETTINGS ---
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      # Принудительно используем только оф. кэш, если ключи других ломают билд
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Отключаем автоматический кэш Chaotic, чтобы он не подсовывал битые ключи
  chaotic.nyx.cache.enable = false;

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

  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };

  zramSwap.enable = true;

  # --- ПАКЕТЫ ---
  environment.systemPackages = with pkgs; [
    vim wget git btop brightnessctl wl-clipboard fastfetch
    unstable.ghostty
  ];

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
