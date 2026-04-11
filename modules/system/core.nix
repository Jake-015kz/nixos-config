{ config, pkgs, ... }:

{
  # --- ЗАГРУЗЧИК ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  # --- ЛОКАЛИ И КОНСОЛЬ ---
  time.timeZone = "Asia/Almaty";
  i18n.defaultLocale = "ru_RU.UTF-8";

  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "ru";
  };

  # --- ШРИФТЫ ---
  fonts.packages = with pkgs; [
    inter
    jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # --- ЗВУК (Pipewire) ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # --- НАСТРОЙКИ NIX И ОЧИСТКА ---
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
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
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # --- ОБЩИЕ ПРОГРАММЫ ---
  programs.fish.enable = true;
  programs.nix-ld.enable = true;
}
