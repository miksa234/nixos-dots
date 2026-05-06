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

  config.flake = {
    nixosConfigurations = lib.flip lib.mapAttrs config.configurations.nixos (
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

    checks = lib.listToAttrs (
      lib.flatten (
        lib.flip lib.mapAttrsToList config.configurations.nixos (
          name:
          { module }:
          let
            nixos = inputs.nixpkgs.lib.nixosSystem {
              system = config.linuxSystem;
              specialArgs = {
                inherit inputs;
                hostName = name;
                isDarwin = false;
                isWayland = config.isWayland;
              };
              modules = [ module ];
            };
          in
          lib.optional (config.flake.nixosConfigurations != { }) {
            name = "nixos-${name}";
            value = nixos.config.system.build.toplevel;
          }
        )
      )
    );
  };
}
