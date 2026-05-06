# Configuration variables
hostname := `hostname`
user := `whoami`

# ============================================================================
# Global / Utility Commands
# ============================================================================

# Show all available configurations
show-configs:
    @nix flake show

# Run flake checks
check:
    nix flake check

# Format and lint Nix files
fmt:
    nix fmt

# Run garbage collection
gc:
    sudo nix-collect-garbage --delete-older-than 1d
    nix-collect-garbage --delete-older-than 7d

# Clean build artifacts
clean:
    rm -rf ./result
    rm -f *.qcow2

# Show flake metadata
flake-info:
    nix flake metadata

# Check all configurations compile
check-all: check mac-build server-build frame-build

# List NixOS packages
ls-nixos-packages:
    @nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq

# List home-manager packages
ls-hm-packages:
    @home-manager packages | sort | uniq

# ============================================================================
# Home Manager
# ============================================================================

# Rebuild home-manager
hm target="xorg":
    {{ if target == "wayland" { "IS_WAYLAND='1' " } else { "" } }}home-manager switch -b backup --flake ./#{{user}} --show-trace

# ============================================================================
# Generic OS (NixOS) Commands
# ============================================================================

# Rebuild NixOS system
os target="xorg":
    sudo {{ if target == "wayland" { "IS_WAYLAND=1 " } else { "" } }} nixos-rebuild switch --flake ./#{{hostname}} --show-trace

# Rollback NixOS
os_rollback:
    sudo nixos-rebuild switch --flake --rollback

# Build VM
vm host:
    sudo nix --experimental-features "nix-command flakes" run nixpkgs#nixos-rebuild -- build-vm --flake .#{{host}} --show-trace

# Deploy to remote host
anywhere host target:
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hardware-configuration.nix --flake ./#{{host}} --target-host {{target}}

# ============================================================================
# Mac (Darwin) Configuration
# ============================================================================

# Build mac Darwin configuration
mac-build:
    nix build ".#darwinConfigurations.mac" --show-trace

# Rebuild mac Darwin system
mac-switch:
    sudo darwin-rebuild switch --flake ./#mac

# Rollback mac Darwin
mac-rollback:
    sudo darwin-rebuild switch --flake ./ --rollback

# ============================================================================
# Server Configuration (NixOS)
# ============================================================================

# Build server NixOS configuration
server-build:
    nix build .#nixosConfigurations.server --show-trace

# Rebuild server system
server-switch:
    sudo nixos-rebuild switch --flake ./#server --show-trace

# Rollback server NixOS
server-rollback:
    sudo nixos-rebuild switch --flake ./ --rollback

# Deploy to server host (requires target hostname)
server-deploy target:
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hardware-configuration.nix --flake ./#server --target-host {{target}}

# ============================================================================
# Frame Configuration (NixOS)
# ============================================================================

# Build frame NixOS configuration
frame-build:
    nix build ".#nixosConfigurations.frame.config.system.build.toplevel" --show-trace

# Rebuild frame system
frame-switch:
    sudo nixos-rebuild switch --flake ./#frame --show-trace

# Rollback frame NixOS
frame-rollback:
    sudo nixos-rebuild switch --flake ./ --rollback

# Deploy to frame host (requires target hostname)
frame-deploy target:
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hardware-configuration.nix --flake ./#frame --target-host {{target}}
