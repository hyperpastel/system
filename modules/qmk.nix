{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.neo.qmk;
  udevRule = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
in
{
  options.neo.qmk = {
    enable = lib.mkEnableOption "Enable using QMK";
    use_vial = lib.mkEnableOption "Enable using of vial";
  };

  config = lib.mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
    environment.systemPackages = [
      pkgs.qmk
      pkgs.qmk-udev-rules
    ]
    ++ (if cfg.use_vial then [ pkgs.vial ] else [ ]);

    services.udev.extraRules = lib.mkIf cfg.use_vial [ udevRule ];
  };

}
