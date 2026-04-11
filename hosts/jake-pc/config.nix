{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/system/core.nix
    ../../modules/apps/internet.nix
    ../../modules/apps/media.nix
    ../../modules/apps/dev.nix
    ../../modules/apps/cli-tools.nix
    ../../modules/system/performance.nix
    ../../modules/desktop/niri.nix
    ../../modules/services/acestream.nix
  ];

  # --- СЕТЬ ---
  networking.hostName = "jake-pc";
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;

  # --- ЯДРО (Параметры для ASUS TUF / AMD) ---
  boot.kernelParams = [
    "amdgpu.backlight=0"
    "acpi_backlight=vendor"
    "video.use_native_backlight=1"
    "amd_pstate=active"
    "quiet"
  ];

  # --- СЕРВИСЫ ХОСТА ---
  services.fwupd.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.tumbler.enable = true;
  services.lact.enable = true;
  services.ollama.enable = true;
  virtualisation.docker.enable = true;

  # --- ИНТЕРФЕЙС ---
  services.xserver.enable = true;
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "jake";
    sddm = {
      enable = true;
      wayland.enable = false;
    };
    defaultSession = "niri";
  };

  # --- ПОЛЬЗОВАТЕЛЬ ---
  users.users.jake = {
    isNormalUser = true;
    description = "Jake";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" "docker" "libvirtd" "gamemode" ];
    shell = pkgs.fish;
  };

  # --- ПАКЕТЫ ---
  environment.systemPackages = with pkgs; [
    wget brightnessctl wl-clipboard fastfetch nh pciutils usbutils duf lsof ltrace
  ];

  environment.sessionVariables = {
    NH_FLAKE = "/home/jake/.dotfiles";
  };

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
