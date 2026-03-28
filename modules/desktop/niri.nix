{ pkgs, inputs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.system}.default
    swaybg
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
  ];

  # Авто-создание ссылки в конфиг пользователя
  systemd.user.tmpfiles.rules = [
    "L+ %h/.config/niri/config.kdl - - - - /etc/niri/config.kdl"
  ];

  environment.etc."niri/config.kdl".text = ''
    // --- ВВОД И РАСКЛАДКА ---
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

    // --- ВНЕШНИЙ ВИД ---
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

    // --- ПРАВИЛА ОКОН ---
    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }

    window-rule {
        match app-id="fuzzel"
        block-out-from "screen-capture"
    }

    // --- ГОРЯЧИЕ КЛАВИШИ ---
    binds {
        // Терминал и Лаунчер
        Super+Return { spawn "ghostty"; }
        Super+D { spawn "noctalia-launcher"; } 
        Super+Q { close-window; }
        Super+F { maximize-column; }
        Super+Space { toggle-window-floating; }

        // Навигация (Vim-style)
        Super+H { focus-column-left; }
        Super+L { focus-column-right; }
        Super+K { focus-window-up; }
        Super+J { focus-window-down; }

        // Перемещение окон
        Super+Ctrl+H { move-column-left; }
        Super+Ctrl+L { move-column-right; }
        Super+Ctrl+K { move-window-up; }
        Super+Ctrl+J { move-window-down; }

        // --- МОНИТОРЫ (HDMI / ТЕЛЕВИЗОР) ---
        Super+Left  { focus-monitor-left; }
        Super+Right { focus-monitor-right; }
        Super+Shift+Left  { move-column-to-monitor-left; }
        Super+Shift+Right { move-column-to-monitor-right; }

        // --- РЕСАЙЗ (Управление размером) ---
        // Переключает между 33% / 50% / 66%
        Super+R { switch-preset-column-width; }
        // Плавный ресайз
        Super+Minus { set-column-width "-10%"; }
        Super+Equal { set-column-width "+10%"; } // Это клавиша Plus без Shift
        Super+Shift+Minus { set-window-height "-10%"; }
        Super+Shift+Equal { set-window-height "+10%"; }

        // Воркспейсы
        Super+1 { focus-workspace 1; }
        Super+2 { focus-workspace 2; }
        Super+3 { focus-workspace 3; }
        Super+Shift+1 { move-column-to-workspace 1; }
        Super+Shift+2 { move-column-to-workspace 2; }
        Super+Shift+3 { move-column-to-workspace 3; }

        // Мультимедиа (ASUS TUF)
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute        { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86MonBrightnessUp   { spawn "brightnessctl" "set" "10%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

        // Скриншоты (исправлено на wl-copy)
        Print { spawn "grim" "-g" "$(slurp)" "-t" "png" "- | wl-copy"; }

        // Выход
        Super+Shift+E { quit; }
    }

    // --- АВТОЗАПУСК ---
    spawn-at-startup "noctalia-shell"
    spawn-at-startup "swaync"
    spawn-at-startup "nm-applet" "--indicator"
    spawn-at-startup "swaybg" "-m" "fill" "-i" "/home/jake/Pictures/wallpaper.png"

    // Анимации
    animations {
        slowdown 1.5
    }
  '';
}
