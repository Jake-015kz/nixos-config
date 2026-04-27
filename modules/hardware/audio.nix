{ config, pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    audio.enable = true;

    extraConfig.pipewire."99-right-channel-only" = {
      "context.modules" = [
        {
          name = "libpipewire-module-loopback";
          args = {
            "node.description" = "MONO Right Speaker";
            "capture.props" = {
              "node.name" = "mono_right_sink";
              "media.class" = "Audio/Sink";
              "audio.position" = [ "MONO" ];
            };
            "playback.props" = {
              # Вот тут мы жестко привязываем звук к твоей карте
              "node.target" = "alsa_output.pci-0000_05_00.6.analog-stereo";
              # И направляем ВСЁ только в правый канал (FR - Front Right)
              "audio.position" = [ "FR" ];
              "node.passive" = true;
            };
          };
        }
      ];
    };
    wireplumber.extraConfig = {
      "10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "a2dp_sink"
            "a2dp_source"
            "headset_head_unit"
            "headset_audio_gateway"
          ];
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    easyeffects
  ];
}
