{
  description = "NixOS and nix-darwin config using dendritic pattern";
  inputs = {
    nixpkgs_stable.url = "nixpkgs/nixos-25.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    niri.url = "github:sodiboo/niri-flake";
    noctalia.url = "github:noctalia-dev/noctalia-shell";

    betterfox.url = "github:HeitorAugustoLN/betterfox-nix";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      {
        imports = [
          inputs.flake-parts.flakeModules.modules
          (inputs.import-tree.matchNot ".*/core/dendritic\\.nix$" ./modules)
        ];

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
      };
}
