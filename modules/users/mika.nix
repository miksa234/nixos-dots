{ ... }:
{
  dendritic.modules = {
    home.user-mika =
      {
        pkgs,
        lib,
        dendritic,
        isDarwin,
        isWayland,
        ...
      }:
      let
        packageSets = dendritic.data.packageSets.default {
          inherit pkgs lib isDarwin;
        };
      in
      {
        nixpkgs.config.allowUnfree = true;

        home =
          {
            username = "mika";
            stateVersion = if isDarwin then "25.11" else "26.05";
            packages = lib.flatten (
              with packageSets;
              [
                system
                shell
                cli
                media
                fileManagement
                communication
                network
                office
                fonts
                email
                development
              ]
              ++ lib.optionals (!isDarwin && !isWayland) [ xorg ]
              ++ lib.optionals isWayland [ wayland ]
            );

            file.".config/nix-zsh-plugins.zsh".text = ''
              source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
              source ${pkgs.zsh-system-clipboard}/share/zsh/zsh-system-clipboard/zsh-system-clipboard.zsh
            '';
          }
          // lib.optionalAttrs (!isDarwin) {
            homeDirectory = "/home/mika";
          };
      };

    nixos.user-mika =
      { pkgs, ... }:
      {
        users.users.mika = {
          isNormalUser = true;
          description = "Mika";
          extraGroups = [
            "networkmanager"
            "wheel"
            "docker"
            "kvm"
            "libvirtd"
          ];
          shell = pkgs.zsh;
        };
      };

    darwin.user-mika =
      { pkgs, ... }:
      {
        users.users.mika = {
          shell = pkgs.zsh;
          home = "/Users/mika";
        };

        system.primaryUser = "mika";
      };
  };
}
