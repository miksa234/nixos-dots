{
  disko.devices = {
    disk = {
      my-disk = {
        device = "/dev/vda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                mountpoint = "/boot";
                type = "filesystem";
                format = "vfat";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
                size = "8G";
                content = {
                    type ="swap";
                    resumeDevice = true;
                };
            };
            root = {
              size = "100%";
              content = {
                mountpoint = "/";
                type = "filesystem";
                format = "ext4";
              };
            };
          };
        };
      };
    };
  };
}
