{ lib, ... }:

{
  options.neo.unfreePredicate = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };
}
