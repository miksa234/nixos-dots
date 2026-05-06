{
  config,
  ...
}:
{
  dendritic.data.packageSets.default =
    {
      pkgs,
      lib,
      isDarwin ? false,
    }:
    let
      suckless = config.dendritic.data.packageSetSuckless {
        inherit pkgs lib;
      };
      systemSlice = config.dendritic.data.packageSetSystem {
        inherit pkgs lib;
      };
      desktopSlice = config.dendritic.data.packageSetLinuxDesktop {
        inherit pkgs lib isDarwin suckless;
      };
      developmentSlice = config.dendritic.data.packageSetDevelopment {
        inherit pkgs;
      };
    in
    systemSlice // desktopSlice // developmentSlice;
}
