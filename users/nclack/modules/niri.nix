{
  config,
  lib,
  pkgs,
  ...
}: let
  dmsSettings = pkgs.writeText "dms-initial-settings.json" (builtins.toJSON {
    currentThemeName = "custom";
    currentThemeCategory = "generic";
    customThemeFile = "${config.home.homeDirectory}/.config/DankMaterialShell/themes/warm.json";
    runUserMatugenTemplates = true;
  });

  dmsSession = pkgs.writeText "dms-initial-session.json" (builtins.toJSON {
    isLightMode = false;
    themeModeAutoEnabled = false;
    themeModeAutoMode = "time";
    themeModeStartHour = 18;
    themeModeStartMinute = 0;
    themeModeEndHour = 6;
    themeModeEndMinute = 0;
  });
in {
  home.packages = with pkgs; [
    dms-shell
    quickshell
    matugen
    dgop
    dsearch
    cava
    khal
    satty
    snapshot
  ];

  xdg.configFile = {
    "niri/config.kdl".source = ../config/niri/config.kdl;
    "DankMaterialShell/themes/warm.json".source = ../config/dms/warm.json;
  };

  # These files must stay mutable so DMS's settings and keybinding editors can
  # update them. Seed them only on the first Home Manager activation.
  home.activation.seedDmsConfiguration = lib.hm.dag.entryAfter ["writeBoundary"] ''
    settings_file="$HOME/.config/DankMaterialShell/settings.json"
    session_file="$HOME/.local/state/DankMaterialShell/session.json"
    binds_file="$HOME/.config/niri/dms/binds.kdl"

    if [ ! -e "$settings_file" ]; then
      run mkdir -p "$(dirname "$settings_file")"
      run install -m 600 ${dmsSettings} "$settings_file"
    fi
    if [ ! -e "$session_file" ]; then
      run mkdir -p "$(dirname "$session_file")"
      run install -m 600 ${dmsSession} "$session_file"
    fi
    if [ ! -e "$binds_file" ]; then
      run mkdir -p "$(dirname "$binds_file")"
      run install -m 600 ${../config/niri/binds.kdl} "$binds_file"
    fi
  '';

  # Bind DMS to Niri's compositor unit rather than graphical-session.target.
  systemd.user.services.dms = {
    Unit = {
      Description = "Dank Material Shell for Niri";
      PartOf = ["niri.service"];
      After = ["niri.service"];
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "${lib.getExe pkgs.dms-shell} run --session";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install.WantedBy = ["niri.service"];
  };
}
