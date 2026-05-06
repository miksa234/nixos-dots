{
  lib,
  config,
  inputs,
  ...
}:
{
  perSystem = { pkgs, lib, system, ... }:
    let
      isLinux = system == "x86_64-linux";
      checksMap = lib.flip lib.mapAttrsToList config.configurations.nixos (
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
        {
          name = "nixos-${name}";
          value = nixos.config.system.build.toplevel;
        }
      );
    in
    {
      checks = 
        if isLinux && config.flake.nixosConfigurations != { } then
          lib.listToAttrs checksMap
        else
          { };
    };
}
