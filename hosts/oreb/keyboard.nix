{services, ...}: {
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
    # Force dock USB controller to initialize earlier
    SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
    # Keychron Q8
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0181", TAG+="uaccess", TAG+="udev-acl"
    # General rules for VIA-compatible keyboards
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", GROUP="plugdev"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="03a8", GROUP="plugdev", MODE="0666"
    # Rules for QMK-compatible keyboards
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff0", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="feed", ATTRS{idProduct}=="6060", TAG+="uaccess", TAG+="udev-acl"
    # Additional rules for other common keyboard vendors
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", MODE="0666"
  '';
}
