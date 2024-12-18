{ disks ? [ "/dev/disk/by-id/scsi-1SKhynix" ], ... }:
{
  disko.devices = {
    disk = {
      nvme = {
        device = "/dev/disk/by-id/scsi-1SKhynix";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
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
