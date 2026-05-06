{
  lib,
  config,
  inputs,
  ...
}:
{
  config.flake = {
    darwinConfigurations = lib.mapAttrs (
      name: cfg:
      let
        resolve =
          moduleName:
          if builtins.hasAttr moduleName config.dendritic.modules.darwin then
            builtins.getAttr moduleName config.dendritic.modules.darwin
          else
            throw "Unknown dendritic Darwin module `${moduleName}` for host `${name}`.";
      in
      inputs.nix-darwin.lib.darwinSystem {
        system = cfg.system;
        specialArgs = {
          inherit inputs;
          isDarwin = true;
          hostName = lib.attrByPath [ name ] name config.hostNames;
          systemName = cfg.system;
          isWayland = config.isWayland;
          dendritic = config.dendritic;
        };
        modules = map resolve cfg.modules;
      }
    ) config.dendritic.configs.darwin;
  };
}
