{
  lib,
  appimageTools,
  fetchurl,
}:
# Due to SSL_ERROR_NO_CYPHER_OVERLAP issues, we need to use a local file.
# 1. Download the AppImage manually from https://cursor.sh
# 2. Save it as pkgs/cursor-0.44.9.AppImage
# 3. Make sure the permissions are correct: chmod +x pkgs/cursor-0.44.9.AppImage
appimageTools.wrapType2 {
  name = "cursor";
  version = "0.44.9";

  # Use the local AppImage file instead of fetchurl
  src = ./cursor-0.44.9.AppImage;

  meta = with lib; {
    description = "Cursor IDE - An AI-first code editor";
    homepage = "https://cursor.sh";
    license = licenses.unfree;
    maintainers = [];
    platforms = ["x86_64-linux"];
  };
}
