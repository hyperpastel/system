{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.neo.gaming;

  mkIfSteam = lib.mkIf cfg.steam.enable;
  mkIfClipping = lib.mkIf cfg.clipping.enable;
  mkIfNVIDIA = lib.mkIf cfg.isNVIDIA;
  mkIfDiscord = lib.mkIf cfg.discord.enable;

in
{

  imports = [
    ../hosts/common/unfree.nix
  ];

  options.neo.gaming = {
    steam.enable = lib.mkEnableOption "Enable using steam";
    clipping.enable = lib.mkEnableOption "Enable clipping through screen recorder";
    isNVIDIA = lib.mkOption {
      type = lib.types.bool;
      description = "Whether the system uses an NVIDIA GPU";
    };
    discord.enable = lib.mkEnableOption "Enable using discord";
  };

  config = {

    # Steam
    programs.steam.enable = mkIfSteam true;
    hardware.graphics.enable = mkIfSteam true;

    # NVIDIA
    services.xserver.videoDrivers = mkIfNVIDIA [ "nvidia" ];

    hardware.nvidia = mkIfNVIDIA {
      modesetting.enable = true;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Clipping
    programs.gpu-screen-recorder.enable = mkIfClipping true;

    environment.systemPackages =
      with pkgs;
      lib.optionals cfg.discord.enable [ vesktop ]
      ++ lib.optionals cfg.clipping.enable [ gpu-screen-recorder-gtk ];

    neo.unfreePredicate =
      lib.optionals cfg.steam.enable [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ]
      ++ lib.optionals cfg.isNVIDIA [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
      ]
      ++ lib.optionals cfg.discord.enable [
        "vesktop"
      ];
  };

}
