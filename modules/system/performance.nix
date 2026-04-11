{ config, pkgs, lib, ... }:

{
  # --- ПИТАНИЕ И ЧАСТОТЫ ---
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "always";
    };
    battery = {
      governor = "powersave";
      turbo = "auto";
    };
  };

  services.power-profiles-daemon.enable = lib.mkForce false;

  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  services.supergfxd.enable = true;


  programs.gamemode.enable = true;

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "vm.vfs_cache_pressure" = 50;
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "kernel.sched_autogroup_enabled" = 0;
  };



  # --- ЖЕЛЕЗО ---
  services.fstrim.enable = true;
  services.irqbalance.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
      rocmPackages.clr.icd
    ];
  };

  environment.systemPackages = with pkgs; [
    lact
    asusctl
    nvtopPackages.amd
    gdu
    lm_sensors
    mesa-demos
  ];

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };
}
