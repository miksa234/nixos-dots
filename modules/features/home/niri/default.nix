{ ... }:
{
  dendritic.modules.home.niri =
    {
      lib,
      inputs,
      pkgs,
      isWayland,
      dendritic,
      ...
    }:
    {
      imports = lib.optionals isWayland [
        inputs.niri.homeModules.niri
      ];

      config = lib.mkIf isWayland {
        programs.niri = {
          enable = true;
          settings = {
            prefer-no-csd = true;
            hotkey-overlay.skip-at-startup = true;
            overview.backdrop-color = "#000000";

            window-rules = dendritic.data.niriRules;
            workspaces = dendritic.data.niriWorkspaces;
            binds = dendritic.data.niriBinds { inherit lib pkgs; };
            layout = dendritic.data.niriLayout;
            cursor = dendritic.data.niriCursor;
            xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
            spawn-at-startup = dendritic.data.niriAutostart { inherit lib pkgs; };
            outputs = dendritic.data.niriOutputs;
            input = dendritic.data.niriInput;
          };
        };
      };
    };
}
