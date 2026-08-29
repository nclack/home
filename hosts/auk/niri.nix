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
    compositor.name = "niri";
    configHome = "/home/nclack";
  };

  # Niri 26.04 starts xwayland-satellite automatically when it is on PATH.
  environment.systemPackages = [pkgs.xwayland-satellite];
}
