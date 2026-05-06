{
  lib,
  config,
  inputs,
  ...
}:
{
  config.flake.nixosConfigurations = lib.mapAttrs (
    name: cfg:
    let
      resolve =
        moduleName:
        if builtins.hasAttr moduleName config.dendritic.modules.nixos then
          builtins.getAttr moduleName config.dendritic.modules.nixos
        else
          throw "Unknown dendritic NixOS module `${moduleName}` for host `${name}`.";
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = cfg.system;
      specialArgs = {
        inherit inputs;
        hostName = lib.attrByPath [ name ] name config.hostNames;
        systemName = cfg.system;
        isDarwin = false;
        isWayland = config.isWayland;
        dendritic = config.dendritic;
      };
      modules = map resolve cfg.modules;
    }
  ) config.dendritic.configs.nixos;
}
