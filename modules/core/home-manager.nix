{
  lib,
  config,
  inputs,
  ...
}:
{
  config.flake = {
    homeConfigurations = lib.mapAttrs (
      name: cfg:
      let
        resolve =
          moduleName:
          if builtins.hasAttr moduleName config.dendritic.modules.home then
            builtins.getAttr moduleName config.dendritic.modules.home
          else
            throw "Unknown dendritic Home Manager module `${moduleName}` for profile `${name}`.";

        system = cfg.system;
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = map resolve cfg.modules;
        extraSpecialArgs = {
          inherit system;
          hostName = lib.attrByPath [ name ] name config.hostNames;
          isDarwin = cfg.isDarwin;
          isWayland = config.isWayland;
          inherit inputs;
          dendritic = config.dendritic;
        };
      }
    ) config.dendritic.configs.home;
  };
}
