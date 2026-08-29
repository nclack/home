{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.dank-greeter.nixosModules.default];

  # Keep COSMIC intact while exposing Niri as an additional greeter session.
  # Keep COSMIC as the fallback default if autologin is enabled again later.
  services.displayManager.defaultSession = "cosmic";

  programs.niri.enable = true;

  # Use the DMS companion greeter on auk while retaining COSMIC as a session.
  services.displayManager.cosmic-greeter.enable = lib.mkForce false;
  programs.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/nclack";
  };

  # Niri 26.04 starts xwayland-satellite automatically when it is on PATH.
  environment.systemPackages = [pkgs.xwayland-satellite];
}
