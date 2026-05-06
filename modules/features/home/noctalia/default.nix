{ ... }:
{
  dendritic.modules.home.noctalia =
    { inputs, lib, isWayland, dendritic, ... }:
    {
      imports = lib.optionals isWayland [
        inputs.noctalia.homeModules.default
      ];

      config = lib.mkIf isWayland {
        programs.noctalia-shell = {
          enable = true;
          colors = dendritic.data.noctaliaColors;
          settings =
            dendritic.data.noctaliaSettings
            // {
              bar =
                dendritic.data.noctaliaBar
                // {
                  widgets = dendritic.data.noctaliaWidgets;
                };
            };
        };
      };
    };
}
