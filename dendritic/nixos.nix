{
  lib,
  config,
  inputs,
  ...
}:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
          description = "The NixOS module for this configuration";
        };
      }
    );
    default = { };
    description = "NixOS configurations to generate";
  };

  config.flake.nixosConfigurations = lib.flip lib.mapAttrs config.configurations.nixos (
    name:
    { module }:
    inputs.nixpkgs.lib.nixosSystem {
      system = config.linuxSystem;
      specialArgs = {
        inherit inputs;
        hostName = name;
        isDarwin = false;
        isWayland = config.isWayland;
      };
      modules = [ module ];
    }
  );
}
