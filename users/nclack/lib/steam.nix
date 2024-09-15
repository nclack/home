{config,lib,...}:

with lib;

mkIf config.services.xserver.enable {
	programs.steam.enable = true;
}

