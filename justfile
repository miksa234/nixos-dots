hostname := `hostname`
user := `whoami`

# Show all available configurations
show-configs:
    @nix flake show

# Rebuild NixOS system
os target="xorg":
    sudo {{ if target == "wayland" { "IS_WAYLAND=1 " } else { "" } }} nixos-rebuild switch --flake ./#{{hostname}} --show-trace

# Rebuild Darwin system
darwin:
    sudo darwin-rebuild switch --flake ./#{{hostname}}

# Rollback Darwin
darwin_rollback:
    sudo darwin-rebuild switch --flake --rollback

# Rollback NixOS
os_rollback:
    sudo nixos-rebuild switch --flake --rollback

# Rebuild home-manager
hm target="xorg":
    {{ if target == "wayland" { "IS_WAYLAND='1' " } else { "" } }}home-manager switch -b backup --flake ./#{{user}} --show-trace

# Run garbage collection
gc:
    sudo nix-collect-garbage --delete-older-than 1d
    nix-collect-garbage --delete-older-than 7d

# List NixOS packages
ls-nixos-packages:
    @nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq

# List home-manager packages
ls-hm-packages:
    @home-manager packages | sort | uniq

# Build VM
vm host:
	sudo nix --experimental-features "nix-command flakes" run nixpkgs#nixos-rebuild --  build-vm --flake .#{{host}} --show-trace

# Deploy to remote host
anywhere host target:
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hardware-configuration.nix --flake ./#{{host}} --target-host {{target}}

# Clean build artifacts
clean:
	rm -r ./result
	rm -f *qcow2

# Build current NixOS configuration
build target="xorg":
    nix build .#nixosConfigurations.{{hostname}}

# Build frame NixOS
build-frame:
    nix build .#nixosConfigurations.frame --show-trace

# Build server NixOS
build-server:
    nix build .#nixosConfigurations.server --show-trace

# Build mac Darwin (if available)
build-mac:
    nix build .#darwinConfigurations.mac --show-trace

# Run flake checks
check:
    nix flake check

# Format and lint Nix files
fmt:
    nix fmt

# Check all configurations compile
check-all: check build-frame build-server

# Show flake metadata
flake-info:
    nix flake metadata
