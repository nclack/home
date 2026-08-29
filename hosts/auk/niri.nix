{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.dank-greeter.nixosModules.default];

  services.displayManager.defaultSession = "niri";

  programs.niri.enable = true;
  services.accounts-daemon.enable = true;

  programs.dms-greeter = {
    enable = true;
    compositor = {
      name = "niri";
      customConfig = ''
        hotkey-overlay {
          skip-at-startup
        }

        environment {
          DMS_RUN_GREETER "1"
        }

        gestures {
          hot-corners {
            off
          }
        }

        layout {
          background-color "#000000"
        }

        output "Dell Inc. DELL P2721Q 4C2ZG93" {
          scale 1.5
          transform "90"
        }
      '';
    };
    configHome = "/home/nclack";
  };

  # Niri 26.04 starts xwayland-satellite automatically when it is on PATH.
  environment.systemPackages = [pkgs.xwayland-satellite];
}
