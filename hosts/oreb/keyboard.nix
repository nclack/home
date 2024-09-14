{services,...}:
{
  # allow access to USB devices for flashing.
  # Should help with using e.g. vial.
  # Vendor id's cover various kb manufacturers:
  #
  # feed: Used by many custom keyboards
  # 1209: Used by many QMK-compatible keyboards
  # 1d50: Used by some keyboard firmware flashers
  # 03eb: Used by LUFA-based devices (including some keyboards)
  # 2341: Used by Arduino boards (sometimes used in custom keyboards)
  # 16c0: Used by Teensy boards (often used in custom keyboards)
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="feed", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", MODE:="0666"
  '';
}
