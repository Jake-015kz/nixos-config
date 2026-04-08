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
    ../../modules/system/performance.nix
    ../../modules/desktop/niri.nix
    # Модуль acestream.nix больше не нужен, так как всё работает через Docker ниже
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

  services.supergfxd.enable = true;

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

  services.displayManager.defaultSession = "niri";

  # --- NIX SETTINGS ---
  nixpkgs.config = {
    allowUnfree = true;

    # Эти хаки можно оставить, если используешь Python 3.10 в разработке, 
    # но для AceStream они теперь не обязательны.
    packageOverrides = pkgs: {
      python310 = pkgs.python310.override {
        packageOverrides = self: super: {
          certifi = super.certifi.overridePythonAttrs (oldAttrs: {
            doCheck = false;
          });
          apsw = super.apsw.overridePythonAttrs (oldAttrs: {
            doCheck = false;
          });
        };
      };
    };
  };

  chaotic.nyx.cache.enable = true;

  # --- ACESTREAM DOCKER SERVICE ---
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers."acestream-engine" = {
    image = "vstavrinov/acestream-engine";
    extraOptions = [ 
      "--net=host" 
      "--pid=host"
    ];
    volumes = [
      "/home/jake/.ACEStream:/home/acestream/.ACEStream"
      "/tmp/acestream:/tmp/acestream"
    ];
  };

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

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  networking.hostName = "jake-pc";
  networking.networkmanager.enable = true;

  # Поддержка Docker
  virtualisation.docker.enable = true;

  # --- СИСТЕМНЫЕ ПАКЕТЫ ---
  environment.systemPackages = with pkgs; [
    wget
    brightnessctl
    wl-clipboard
    fastfetch
    nh
    pciutils
    usbutils
    lm_sensors
    pkgs.asusctl
    steam-run
  ];

  environment.sessionVariables = {
    NH_FLAKE = "/home/jake/.dotfiles";
  };

  # Поддержка запуска сторонних бинарников (nix-ld)
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
    glib
    libuuid
  ];

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  system.stateVersion = "25.11";
}
