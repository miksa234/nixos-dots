{ ... }:
let
  rootHomeManager =
    { lib, isDarwin ? false, ... }:
    {
      environment.pathsToLink =
        lib.optionals (!isDarwin) [
          "/share/applications"
          "/share/xdg-desktop-portal"
        ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        users.root =
          { ... }:
          {
            home =
              {
                username = "root";
                stateVersion = if isDarwin then "25.05" else "25.11";
                file.".local/bin/.keep".text = "";
              }
              // lib.optionalAttrs (!isDarwin) {
                homeDirectory = "/root";
              };
          };
      };
    };
in
{
  dendritic.modules.nixos.root =
    { pkgs, ... }:
    {
      imports = [ rootHomeManager ];

      users.users.root.shell = pkgs.zsh;
    };

  dendritic.modules.darwin.root =
    { pkgs, ... }:
    {
      imports = [ rootHomeManager ];

      users.users.root = {
        shell = pkgs.zsh;
        home = "/var/root";
      };
    };
}
