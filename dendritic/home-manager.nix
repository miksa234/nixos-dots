{
  lib,
  config,
  inputs,
  ...
}:
{
  options.configurations.homeManager = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
          description = "The home-manager module for this configuration";
        };
      }
    );
    default = { };
    description = "Home-manager configurations to generate";
  };

  config.flake = {
    homeConfigurations = lib.flip lib.mapAttrs config.configurations.homeManager (
      name:
      { module }:
      let
        system = config.linuxSystem;
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        isDarwin = false;
      in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ module ];
        extraSpecialArgs = {
          inherit system;
          inherit isDarwin;
          isWayland = config.isWayland;
          inherit inputs;
        };
      }
    );
  };
}
