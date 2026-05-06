{
  config,
  pkgs,
  lib,
  ...
}:

let
  isHomeManager = config ? home;
in
{
  nix = {
    enable = true;
    package = pkgs.nix;
    settings = {
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "mika"
        "root"
      ];
    };
  }
  // lib.optionalAttrs (!isHomeManager) {
    channel.enable = false;
  };
}
