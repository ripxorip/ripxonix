# Beelink SER3, one 480 GB NVMe.
#
# Laid out for what the amp becomes, not just for what it is tonight. Two
# decisions are worth the ink, because both are painful to change after the
# box is bolted into a cabinet:
#
# 1. The ESP is 8 GiB, not the usual 512 MiB. Perform mode (ultimate_amp_fw
#    docs/architecture.md §13) boots a RAM root built from
#    `system.build.netbootRamdisk`, and that is a *single initrd file with
#    the entire store squashfs inside it* which the bootloader has to load —
#    so it lives on the ESP, next to the bench generations. Growing the ESP
#    later means moving the start of every partition after it. 8 GiB is 1.6%
#    of the disk.
#
#    Note the ceiling that comes with it: FAT32 caps one file at 4 GiB, so
#    the perform closure has to fit under that no matter how big the ESP is.
#    If it ever doesn't, the fallback is a small initrd that mounts the
#    squashfs off btrfs and copies it to tmpfs — which is another reason the
#    rest of the disk is one resizable pool rather than fixed partitions.
#
# 2. Everything else is one btrfs with subvolumes instead of sized
#    partitions, so "how big should root be" is a question we never have to
#    answer wrong. `@amp` exists from day one and holds everything perform
#    mode needs writable — Wine prefix, Reaper resource dir, NAM models,
#    rigs — so switching to perform mode is a change of boot method, not a
#    data migration, and §14's read-only-prefix test gets run against the
#    real location. New subvolumes later cost nothing, and btrfs shrinks
#    online if a genuine partition is ever needed in the tail.
#
# No swap: 16 GB, and perform mode wants `swapDevices = [ ]` anyway.
{ disks ? [ "/dev/nvme0n1" ], ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "8G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/@root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # State, deliberately kept off the root subvolume. This is
                  # the partition §13 calls for; it is simply always mounted
                  # in bench mode.
                  "/@amp" = {
                    mountpoint = "/amp";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
