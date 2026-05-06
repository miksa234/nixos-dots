{ config, inputs, ... }:
{
  configurations.nixos.frame.module = ./frame-full-config.nix;
}
