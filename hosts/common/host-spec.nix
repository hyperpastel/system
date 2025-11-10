{ lib, ... }:

{
  options.neo.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      options = {

        hostName = lib.mkOption {
          type = lib.types.str;
          description = "The hostname of the system";
        };

        isWireless = lib.mkOption {
          type = lib.types.bool;
          description = "Whether the system is wireless";
          default = false;
        };

        impermanence = {
          isEnabled = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether the system is impermanent and needs persisting settings";
          };

          # TODO Using this, impermanence logic can be further simplified
          passwordPath = lib.mkOption {
            type = lib.types.str;
            description = "Path to the hashed password file";
          };

        };

      };
    };
  };
}
