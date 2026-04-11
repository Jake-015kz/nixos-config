{ pkgs, inputs, ... }:

{
  programs.niri.enable = true;

  # Настройки системы (теперь на своем месте)
  services.logind.settings.Login.HandleLidSwitch = "ignore";

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
    wlogout # Добавили меню выхода
    wl-screenrec # Добавили запись экрана
  ];

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

    // Затемнение неактивных окон (фокус на главном)
    window-rule {
        match is-active=false
        opacity 0.8
    }

    // --- ГОРЯЧИЕ КЛАВИШИ ---
    binds {
        Super+Return { spawn "ghostty"; }
        Super+D { spawn "fuzzel"; }
        Super+B { spawn "firefox"; }
        Super+Q { close-window; }
        Super+F { maximize-column; }
        Super+Space { toggle-window-floating; }

        // Навигация
        Super+H { focus-column-left; }
        Super+L { focus-column-right; }
        Super+K { focus-window-up; }
        Super+J { focus-window-down; }

        // Мониторы
        Super+Left  { focus-monitor-left; }
        Super+Right { focus-monitor-right; }
        Super+Shift+Left  { move-column-to-monitor-left; }
        Super+Shift+Right { move-column-to-monitor-right; }

        // Ресайз
        Super+R { switch-preset-column-width; }
        Super+Minus { set-column-width "-10%"; }
        Super+Equal { set-column-width "+10%"; }

        // Мультимедиа
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute        { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86MonBrightnessUp   { spawn "brightnessctl" "set" "10%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

        // Скриншот (в буфер)
        Print { spawn "sh" "-c" "grim -g \"$(slurp)\" -t png - | wl-copy"; }

        // Красивое меню выхода вместо простого quit
        Super+Shift+E { spawn "wlogout"; }
    }

    // --- АВТОЗАПУСК ---
    spawn-at-startup "noctalia-shell"
    spawn-at-startup "swaync"
    spawn-at-startup "nm-applet" "--indicator"
    spawn-at-startup "swaybg" "-m" "fill" "-i" "/home/jake/Pictures/asus.jpg"

    animations {
        slowdown 1.5
    }
  '';
}
