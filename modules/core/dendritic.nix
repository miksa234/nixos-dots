{ inputs, ... }:
{
  options.dendritic = with inputs.nixpkgs.lib; {
    modules = {
      nixos = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        description = "Registry of reusable NixOS modules.";
      };

      darwin = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        description = "Registry of reusable nix-darwin modules.";
      };

      home = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        description = "Registry of reusable Home Manager modules.";
      };
    };

    data = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      description = "Registry of shared non-module data.";
    };

    configs = {
      nixos = mkOption {
        type = types.lazyAttrsOf (
          types.submodule {
            options = {
              modules = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "NixOS module registry entries used for this host.";
              };

              system = mkOption {
                type = types.str;
                default = "x86_64-linux";
                description = "Target system for the generated NixOS configuration.";
              };
            };
          }
        );
        default = { };
        description = "NixOS host compositions.";
      };

      darwin = mkOption {
        type = types.lazyAttrsOf (
          types.submodule {
            options = {
              modules = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Darwin module registry entries used for this host.";
              };

              system = mkOption {
                type = types.str;
                default = "aarch64-darwin";
                description = "Target system for the generated Darwin configuration.";
              };
            };
          }
        );
        default = { };
        description = "Darwin host compositions.";
      };

      home = mkOption {
        type = types.lazyAttrsOf (
          types.submodule {
            options = {
              modules = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Home Manager module registry entries used for this profile.";
              };

              system = mkOption {
                type = types.str;
                default = "x86_64-linux";
                description = "Target system for the generated Home Manager configuration.";
              };

              isDarwin = mkOption {
                type = types.bool;
                default = false;
                description = "Whether the home profile targets Darwin.";
              };
            };
          }
        );
        default = { };
        description = "Home Manager profile compositions.";
      };
    };
  };
}
