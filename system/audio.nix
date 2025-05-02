{ pkgs, ... }:

{
  # Can maybe remove this
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "999999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "999999";
    }
    {
      domain = "*";
      item = "memlock";
      type = "-";
      value = "infinity";
    }
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "8192";
    }
    {
      domain = "hirw";
      item = "nofile";
      type = "hard";
      value = "524288";
    }
  ];

  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    extraConfig.pipewire = {
      # Helps prevent buffer underrun causing stuttering
      "context.properties" = {
        "default.clock.rate" = 44100;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 128;
        "default.clock.max-quantum" = 1024;
      };
    };
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
    socketActivation = true;
  };

  environment.systemPackages = with pkgs; [ pavucontrol ];
}
