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
    services.xserver.enable = true;
    services.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = config.jake.system.user.userName;
      sddm = {
        enable = true;
        wayland.enable = false;
      };
      defaultSession = "niri";
    };

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
      wlogout
      wl-screenrec
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
          Super+Return { spawn "ghostty"; }
          Super+D { spawn "fuzzel"; }
          Super+B { spawn "firefox"; }
          Super+Q { close-window; }
          Super+F { maximize-column; }
          Super+Space { toggle-window-floating; }

          Super+H { focus-column-left; }
          Super+L { focus-column-right; }
          Super+K { focus-window-up; }
          Super+J { focus-window-down; }

          Super+R { switch-preset-column-width; }
          Super+Minus { set-column-width "-10%"; }
          Super+Equal { set-column-width "+10%"; }

          XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
          XF86AudioMute        { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86MonBrightnessUp   { spawn "brightnessctl" "set" "10%+"; }
          XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

          Print { spawn "sh" "-c" "grim -g \"$(slurp)\" -t png - | wl-copy"; }
          Super+Shift+E { spawn "wlogout"; }
      }

      spawn-at-startup "noctalia-shell"
      spawn-at-startup "swaync"
      spawn-at-startup "nm-applet" "--indicator"
      spawn-at-startup "swaybg" "-m" "fill" "-i" "/home/${config.jake.system.user.userName}/Pictures/asus.jpg"

      animations {
          slowdown 1.5
      }
    '';

    systemd.user.tmpfiles.rules = [
      "L+ %h/.config/niri/config.kdl - - - - /etc/niri/config.kdl"
    ];
  };
}
