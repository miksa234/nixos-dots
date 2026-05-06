{
  lib,
  isDarwin ? false,
  ...
}:
{
  environment.pathsToLink =
    if (!isDarwin) then
      [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ]
    else
      [ ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.root =
      { pkgs, config, ... }:
      {

        home = {
          username = "root";
          stateVersion = if isDarwin then "25.05" else "25.11";
          file = {
            ".local/bin/.keep".text = "";
          };
        }
        // lib.optionalAttrs (!isDarwin) {
          homeDirectory = "/root";
        };
      };
  };
}
