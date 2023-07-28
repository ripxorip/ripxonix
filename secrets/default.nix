{ config
, pkgs
, inputs
, username
, ...
}:
let
  agenix = inputs.agenix;
in
{
  environment.systemPackages = [
    agenix.packages."${pkgs.system}".default
  ];

  # Secrets will be enabled again once the iso has been sorted out
  # age.secrets.secret1.file = ./secret1.age;

  age.identityPaths = [
    "/home/${username}/dev/keys/agenix"
  ];
}
