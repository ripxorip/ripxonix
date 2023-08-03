{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        sanoid
    ];
}
