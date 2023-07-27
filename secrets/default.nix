{
  config,
  pkgs,
  inputs,
  username,
  ...
}:
let
    agenix = inputs.agenix;
in
{
  environment.systemPackages = [
    agenix.packages."${pkgs.system}".default
  ];

  age.identityPaths = [
    "/home/${username}/dev/keys/agenix"
  ];
}
