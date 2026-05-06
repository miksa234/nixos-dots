{ lib, inputs, ... }:
{
  options = {
    username = lib.mkOption {
      type = lib.types.singleLineStr;
      default = "mika";
      description = "Primary username";
    };

    hostNames = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        frame = "frame";
        server = "server";
        mac = "mac";
      };
      description = "Mapping of configuration names to hostnames";
    };

    domain = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional domain suffix for hosts";
    };

    isWayland = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "IS_WAYLAND" == "1";
      description = "Whether to use Wayland (set via IS_WAYLAND env var at build time)";
    };

    linuxSystem = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
      readOnly = true;
      description = "Linux system architecture";
    };

    darwinSystem = lib.mkOption {
      type = lib.types.str;
      default = "aarch64-darwin";
      readOnly = true;
      description = "Darwin system architecture";
    };

    inputs = lib.mkOption {
      type = lib.types.attrs;
      default = inputs;
      readOnly = true;
      description = "Flake inputs";
    };
  };
}
