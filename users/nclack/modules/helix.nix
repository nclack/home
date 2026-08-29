{
  config,
  lib,
  pkgs,
  ...
}: let
  darkTheme = "kanagawa-dragon";
  lightTheme = "flexoki_light";

  configTemplate = ../config/helix/config.toml;

  syncScript = pkgs.writeShellApplication {
    name = "helix-theme-sync";
    runtimeInputs = with pkgs; [procps coreutils gnused jq];
    text = ''
      is_dark_file="$HOME/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark"
      dms_session_file="$HOME/.local/state/DankMaterialShell/session.json"
      helix_dir="$HOME/.config/helix"
      config_file="$helix_dir/config.toml"

      # If a previous home-manager generation made $helix_dir a symlink into
      # the nix store, remove it so we can manage config.toml here.
      if [ -L "$helix_dir" ] && readlink "$helix_dir" | grep -q '^/nix/store/'; then
        rm "$helix_dir"
      fi
      mkdir -p "$helix_dir"

      # DMS owns appearance in niri; COSMIC owns it in the COSMIC session.
      # XDG_CURRENT_DESKTOP is imported into the user manager by both sessions.
      case "''${XDG_CURRENT_DESKTOP:-}" in
        *niri*|*NIRI*)
          if [ -f "$dms_session_file" ] && jq -e '.isLightMode == true' "$dms_session_file" >/dev/null 2>&1; then
            is_light=true
          else
            is_light=false
          fi
          ;;
        *)
          if [ -f "$is_dark_file" ] && [ "$(cat "$is_dark_file")" = "false" ]; then
            is_light=true
          else
            is_light=false
          fi
          ;;
      esac

      if [ "$is_light" = true ]; then
        theme="${lightTheme}"
      else
        theme="${darkTheme}"
      fi

      tmp="$(mktemp --tmpdir="$helix_dir" config.toml.XXXXXX)"
      trap 'rm -f "$tmp"' EXIT
      sed "s|^theme = .*|theme = \"$theme\"|" ${configTemplate} > "$tmp"

      if ! cmp -s "$tmp" "$config_file" 2>/dev/null; then
        mv "$tmp" "$config_file"
        pkill -SIGUSR1 -x hx 2>/dev/null || true
      fi
    '';
  };
in {
  home.packages = [syncScript];

  home.file.".config/helix/languages.toml".source = ../config/helix/languages.toml;

  home.activation.helixThemeSync = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${syncScript}/bin/helix-theme-sync
  '';

  systemd.user.services.helix-theme-sync = {
    Unit.Description = "Sync Helix theme to desktop appearance";
    Service = {
      Type = "oneshot";
      ExecStart = "${syncScript}/bin/helix-theme-sync";
    };
    Install.WantedBy = ["default.target"];
  };

  systemd.user.paths.helix-theme-sync = {
    Unit.Description = "Watch desktop appearance to sync Helix theme";
    Path = {
      PathChanged = [
        "%h/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark"
        "%h/.local/state/DankMaterialShell/session.json"
      ];
      Unit = "helix-theme-sync.service";
    };
    Install.WantedBy = ["default.target"];
  };
}
