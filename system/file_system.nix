{ ... }:

{
  # lsblk -f for uuids

  fileSystems."/mnt/HDD" = {
    device = "/dev/disk/by-uuid/01D8BA822599C960";
    fsType = "ntfs-3g";
    options = [
      "users" # Anyone can mount tha HDD!!!!!!
      "nofail" # No biggie if we cant mount it <:-D
      "x-gvfs-show" # Show in thunar
      "rw"
    ];
  };

  fileSystems."/mnt/SSD1" = {
    device = "/dev/disk/by-uuid/CC3E3FAD3E3F8F86";
    fsType = "ntfs";
    options = [
      "users" # Anyone can mount tha SSD!!!!!!
      "nofail" # No biggie if we cant mount it <:-D
      "x-gvfs-show" # Show in thunar
    ];
  };

  fileSystems."/mnt/SSD2" = {
    device = "/dev/disk/by-uuid/01DAEB9EA9367710";
    fsType = "ntfs";
    options = [
      "users" # Anyone can mount tha SSD!!!!!!
      "nofail" # No biggie if we cant mount it <:-D
      "x-gvfs-show" # Show in thunar
    ];
  };
}
