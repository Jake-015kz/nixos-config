{ config
, pkgs
, inputs
, lib
, ...
}:

let
  cfg = config.jake.desktop.niri;
in
{
  options.jake.desktop.niri = {
    enable = lib.mkEnableOption "Niri compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;

    services.logind.settings.Login.HandleLidSwitch = "ignore";
    services.xserver.enable = false;
    services.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = config.jake.system.user.userName;
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "niri";
    };

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.system}.default
      xwayland
      swaynotificationcenter
      fuzzel
      networkmanagerapplet
      wireplumber
      brightnessctl
      playerctl
      asusctl
      libappindicator
      socat
      grim
      slurp
      wl-clipboard
      wlogout
      wl-screenrec
      swaylock # Добавил, так как он есть в биндах
    ];

    environment.etc."niri/config.kdl".text = ''
      input {
          keyboard {
              xkb {
                  layout "us,ru"
                  options "grp:alt_shift_toggle"
              }
          }
          touchpad {
              tap
              natural-scroll
          }
      }

      layout {
          gaps 12
          center-focused-column "never"
          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }
          default-column-width { proportion 0.5; }
          focus-ring {
              width 2
              active-color "#7aa2f7"
              inactive-color "#414868"
          }
      }

      window-rule {
          geometry-corner-radius 12
          clip-to-geometry true
      }

      window-rule {
          match is-active=false
          opacity 0.8
      }

      binds {
          // --- Управление приложениями ---
          Super+Return { spawn "ghostty"; }
          Super+Ctrl+Return { spawn "fuzzel"; }
          Super+B { spawn "firefox"; }
          Super+E { spawn "thunar"; }
          Super+Q { close-window; }
          Super+Alt+L { spawn "swaylock"; }

          // --- Навигация по окнам ---
          Super+Left  { focus-column-left; }
          Super+Right { focus-column-right; }
          Super+Up    { focus-window-up; }
          Super+Down  { focus-window-down; }
          Super+H     { focus-column-left; }
          Super+L     { focus-column-right; }
          Super+K     { focus-window-up; }
          Super+J     { focus-window-down; }
          
          Super+Home { focus-column-first; }
          Super+End  { focus-column-last; }

          // --- Навигация по мониторам (Телевизор) ---
          Super+Shift+Left  { focus-monitor-left; }
          Super+Shift+Right { focus-monitor-right; }
          Super+Shift+Up    { focus-monitor-up; }
          Super+Shift+Down  { focus-monitor-down; }

          // --- Управление окнами (Перемещение) ---
          Super+Ctrl+Left  { move-column-left; }
          Super+Ctrl+Right { move-column-right; }
          Super+Ctrl+Up    { move-window-up; }
          Super+Ctrl+Down  { move-window-down; }
          Super+Ctrl+H     { move-column-left; }
          Super+Ctrl+L     { move-column-right; }
          Super+Ctrl+K     { move-window-up; }
          Super+Ctrl+J     { move-window-down; }

          // --- Перемещение окна на другой монитор ---
          Super+Ctrl+Shift+Left  { move-column-to-monitor-left; }
          Super+Ctrl+Shift+Right { move-column-to-monitor-right; }
          Super+Ctrl+Shift+Up    { move-column-to-monitor-up; }
          Super+Ctrl+Shift+Down  { move-column-to-monitor-down; }

          // --- Рабочие столы (Воркспейсы) ---
          Super+1 { focus-workspace 1; }
          Super+2 { focus-workspace 2; }
          Super+3 { focus-workspace 3; }
          Super+4 { focus-workspace 4; }
          Super+5 { focus-workspace 5; }
          Super+6 { focus-workspace 6; }
          Super+7 { focus-workspace 7; }
          Super+8 { focus-workspace 8; }
          Super+9 { focus-workspace 9; }
          Super+Ctrl+1 { move-column-to-workspace 1; }
          Super+Ctrl+2 { move-column-to-workspace 2; }
          Super+Ctrl+3 { move-column-to-workspace 3; }
          Super+Ctrl+4 { move-column-to-workspace 4; }
          Super+Ctrl+5 { move-column-to-workspace 5; }
          
          Super+Tab { focus-workspace-previous; }

          // --- Управление макетом ---
          Super+R { switch-preset-column-width; }
          Super+F { maximize-column; }
          Super+Ctrl+F { fullscreen-window; }
          Super+C { center-column; }
          
          Super+Minus { set-column-width "-10%"; }
          Super+Equal { set-column-width "+10%"; }
          Super+Shift+Minus { set-window-height "-10%"; }
          Super+Shift+Equal { set-window-height "+10%"; }

          Super+W { toggle-column-tabbed-display; }
          Super+O { toggle-overview; }

          // --- Мультимедиа ---
          XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
          XF86AudioMute        { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86MonBrightnessUp   { spawn "brightnessctl" "set" "10%+"; }
          XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

          // --- Системные ---
          Print { spawn "sh" "-c" "grim -g \"$(slurp)\" -t png - | wl-copy"; }
          Super+Shift+E { spawn "wlogout"; }
          Super+Escape { toggle-keyboard-shortcuts-inhibit; } // Из документации
          Ctrl+Alt+Delete { quit; }
      }

      spawn-at-startup "noctalia-shell"
      spawn-at-startup "swaync"
      spawn-at-startup "nm-applet" "--indicator"

      animations {
          slowdown 1.5
      }
    '';

    systemd.user.tmpfiles.rules = [
      "L+ %h/.config/niri/config.kdl - - - - /etc/niri/config.kdl"
    ];
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
    };
  };
}
