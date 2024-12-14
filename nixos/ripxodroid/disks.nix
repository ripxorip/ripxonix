{ disks ? [ "/dev/nvme0n1" ], ... }:
{
  disko.devices = {
    disk = {
      nvme0 = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              start = "0%";
              end = "1024MiB";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              start = "1024MiB";
              end = "100%";
              priority = 2;
              content = {
                type = "filesystem";
                # Overwirte the existing filesystem
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
