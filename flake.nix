{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    templates.url = "github:hyperpastel/flake-templates";
  };

  outputs =
    {
      self,
      nixpkgs,
      templates,
      ...
    }@inputs:

    {
      nixosConfigurations.teyvat = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/all.nix
        ];
        specialArgs = { inherit nixpkgs templates; };
      };
    };
}
