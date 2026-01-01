{
  pkgs,
  ...
}:
{
  nix = {
    enable = true;
    package = pkgs.nix;
    settings = {
      use-xdg-base-directories = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "mika" "root" ];
    };
  };
}
