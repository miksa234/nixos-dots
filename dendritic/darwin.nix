{ lib, config, inputs, ... }:
{
  options.configurations.darwin = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
          description = "The nix-darwin module for this configuration";
        };
      }
    );
    default = {};
    description = "nix-darwin configurations to generate";
  };

  config.flake = {
    darwinConfigurations = lib.flip lib.mapAttrs config.configurations.darwin (
      name: { module }: inputs.nix-darwin.lib.darwinSystem {
        system = config.darwinSystem;
        modules = [ module ];
      }
    );
  };
}
