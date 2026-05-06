{ ... }:
{
  dendritic.modules.darwin.host-mac-base =
    {
      hostName,
      inputs,
      systemName,
      ...
    }:
    {
      imports = [
        inputs.home-manager.darwinModules.home-manager
      ];

      nixpkgs.hostPlatform = systemName;
      system.stateVersion = 6;
      networking.hostName = hostName;

      environment.variables = {
        __ETC_ZSHRC_SOURCED = "1";
        __ETC_ZSHENV_SOURCED = "1";
      };

      programs = {
        zsh.enable = true;
        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };

      nixpkgs.config.allowUnfree = true;
    };
}
