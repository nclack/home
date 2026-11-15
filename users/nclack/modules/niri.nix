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
    dux-shell
    quickshell
    matugen
    dux-gop
    dux-search
    cava
    khal
    nautilus
    fragments
    papers
    pixelorama
    satty
    showtime
    snapshot
    tauon
  ];

  xdg.configFile = {
    "niri/config.kdl".source = ../config/niri/config.kdl;
    "DankMaterialShell/themes/warm.json".source = ../config/dms/warm.json;
  };

  # DMS does not honor Terminal=true when launching MIME handlers. Override
  # the terminal applications it uses so their Exec commands allocate a TTY.
  xdg.dataFile = {
    "applications/Helix.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Helix
      GenericName=Text Editor
      Comment=Edit text files
      TryExec=${lib.getExe pkgs.helix}
      Exec=${lib.getExe pkgs.ghostty} -e ${lib.getExe pkgs.helix} %F
      Icon=helix
      Terminal=false
      Categories=Utility;TextEditor;
      MimeType=application/x-shellscript;text/plain;text/x-c;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-makefile;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;
    '';
    "applications/yazi.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Yazi File Manager
      GenericName=File Manager
      Comment=Browse files with Yazi
      TryExec=${lib.getExe pkgs.yazi}
      Exec=${lib.getExe pkgs.ghostty} -e ${lib.getExe pkgs.yazi} %f
      Icon=yazi
      Terminal=false
      Categories=System;FileManager;FileTools;
      MimeType=inode/directory;
    '';
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

    # Keep MIME settings mutable for DMS, but replace terminal-only directory
    # handlers with a graphical one the launcher's Open actions can start.
    directory_handler="$(${pkgs.xdg-utils}/bin/xdg-mime query default inode/directory 2>/dev/null || true)"
    case "$directory_handler" in
      ""|dms-open.desktop|yazi.desktop)
        run ${pkgs.xdg-utils}/bin/xdg-mime default org.gnome.Nautilus.desktop inode/directory
        ;;
    esac
  '';

  # DMS delegates launcher file searches to dsearch's persistent index service.
  systemd.user.services.dsearch = {
    Unit = {
      Description = "dsearch filesystem search service";
      Documentation = ["https://github.com/AvengeMedia/danksearch"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.dux-search} serve";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = ["default.target"];
  };

  # Bind DMS to Niri's compositor unit rather than graphical-session.target.
  systemd.user.services.dms = {
    Unit = {
      Description = "Dank Material Shell for Niri";
      PartOf = ["niri.service"];
      Wants = ["dsearch.service"];
      After = [
        "niri.service"
        "dsearch.service"
      ];
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "${lib.getExe pkgs.dux-shell} run --session";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install.WantedBy = ["niri.service"];
  };
}
