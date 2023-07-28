let
  ripxorip = builtins.readFile ./agenix.pub;
in
{
  "secret1.age".publicKeys = [ ripxorip ];
}
