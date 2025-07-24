{ aagl, lib, ... }:
{
  imports = [ aagl.nixosModules.default ];

  # Required for AAGL
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam-unwrapped"
    ];

  # see modules/system.nix for the corresponding cachix entry
  programs.anime-game-launcher.enable = true;

}
