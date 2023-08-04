{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Shall be the upstream sanoid, using my custom syncoid because
    # of a sudo bug in the sanoid package ("Prefer ZFS userspace tools from /run/booted-system/sw/bin")
    syncoid
  ];
}
