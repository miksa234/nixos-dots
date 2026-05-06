{ config, inputs, ... }:
{
  configurations.nixos.frame.module = import ./frame-full-config.nix;
}
