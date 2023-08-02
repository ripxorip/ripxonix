_: {
  services.caddy = {
    enable = true;

    virtualHosts."mat.karlssongisslow.com".extraConfig = ''
      reverse_proxy ripxolab:9123
    '';

    virtualHosts."molnet.karlssongisslow.com".extraConfig = ''
      reverse_proxy ripxolab:8082
    '';

    virtualHosts."mat.ripxorip.org".extraConfig = ''
      reverse_proxy ripxolab:9123
    '';

    virtualHosts."matrix.ripxorip.org".extraConfig = ''
      reverse_proxy ripxolab:8008
    '';

    virtualHosts."rss.ripxorip.org".extraConfig = ''
      reverse_proxy ripxolab:9654
    '';
  };
}
