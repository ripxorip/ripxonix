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

  age.secrets.secret1.file = ./secret1.age;

  age.identityPaths = [
    "/home/${username}/dev/keys/agenix"
  ];
}
