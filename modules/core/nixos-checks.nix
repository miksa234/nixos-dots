{
  config,
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    let
      isLinux = system == "x86_64-linux";
      checksMap = lib.mapAttrsToList (
        name: cfg:
        let
          resolve =
            moduleName:
            if builtins.hasAttr moduleName config.dendritic.modules.nixos then
              builtins.getAttr moduleName config.dendritic.modules.nixos
            else
              throw "Unknown dendritic NixOS module `${moduleName}` for check `${name}`.";

          nixos = inputs.nixpkgs.lib.nixosSystem {
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
          };
        in
        {
          name = "nixos-${name}";
          value = nixos.config.system.build.toplevel;
        }
      ) config.dendritic.configs.nixos;
    in
    {
      checks =
        if isLinux && config.dendritic.configs.nixos != { } then lib.listToAttrs checksMap else { };
    };
}
