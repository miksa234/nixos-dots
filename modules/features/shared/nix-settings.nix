{ ... }:
let
  nixSettingsModule =
    {
      config,
      pkgs,
      lib,
      osConfig ? null,
      ...
    }:
    let
      isHomeManager = config ? home;
      isSystemManagedHome = isHomeManager && osConfig != null;
    in
    {
      nix =
        {
          enable = true;
          settings = {
            use-xdg-base-directories = true;
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            trusted-users = [
              "mika"
              "root"
            ];
          };
        }
        // lib.optionalAttrs (!isSystemManagedHome) {
          package = pkgs.nix;
        }
        // lib.optionalAttrs (!isHomeManager) {
          channel.enable = false;
        };
    };
in
{
  dendritic.modules.home.nix-settings = nixSettingsModule;
  dendritic.modules.nixos.nix-settings = nixSettingsModule;
  dendritic.modules.darwin.nix-settings = nixSettingsModule;
}
