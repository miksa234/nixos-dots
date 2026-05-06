{ ... }:
{
  dendritic.modules.nixos.networkmanager =
    {
      config,
      dendritic,
      ...
    }:
    {
      imports = [
        dendritic.modules.nixos.networkmanager-secrets
        dendritic.modules.nixos.networkmanager-dispatcher
      ];

      networking.networkmanager = {
        enable = true;
        ensureProfiles = {
          environmentFiles = [ config.sops.templates.wifi.path ];
          profiles =
            dendritic.data.networkmanagerProfilesGajba
            // dendritic.data.networkmanagerProfilesWireguard;
        };
      };
    };
}
