# NixOS & Nix-Darwin Configuration

Modular, cross-platform system configuration using the **dendritic pattern** - a tree-like architecture for managing multiple systems, users, and features with minimal duplication.

**Status**: Frame (Linux) fully migrated to dendritic pattern | Server & Mac using legacy structure

## Quick Links

- 📘 **[DENDRITIC.md](./DENDRITIC.md)** - Complete guide to the dendritic pattern
- 🚀 **[MIGRATION_NOTES.md](./MIGRATION_NOTES.md)** - Migration guide from old structure
- 💾 **[.sops.yaml](./.sops.yaml)** - Secrets management config

## What's Inside

### 🏗️ Architecture

```
dendritic/          ← Core of the configuration
├── features.d/     ← Reusable feature modules (packages, apps, UI)
├── homes.d/        ← Per-user home-manager configurations
└── *-config.nix    ← Host-specific composition files

hosts/              ← Hardware definitions (frame-hardware.nix, etc)
users/              ← Legacy user configs (being migrated)
flake.nix          ← Main entry point
```

### 🖥️ Supported Systems

- **frame** - Framework 13 Laptop (Linux, Wayland, x86_64)
- **mac** - MacBook (Darwin, aarch64)
- **server** - NixOS Server (Linux, x86_64)

### 👥 Managed Users

- `mika` - Primary user (all systems)
- `r2d2` - Secondary user (frame)
- `root` - Root user (all systems)

## Quick Start

### Prerequisites

```bash
# Install NixOS with flakes support
nix flake update

# For macOS
brew install nix
nix flake update
```

### Building & Deploying

#### Linux (NixOS)

```bash
# Build frame system
nix build .#nixosConfigurations.frame.config.system.build.toplevel

# Switch to new configuration (requires sudo)
sudo nixos-rebuild switch --flake .#frame

# View what changed
sudo nixos-rebuild dry-run --flake .#frame
```

#### macOS (Nix-Darwin)

```bash
# Build mac system
nix build .#darwinConfigurations.mac

# Switch to new configuration
darwin-rebuild switch --flake .#mac
```

#### Home-Manager

```bash
# Build home configuration
nix build .#homeConfigurations.mika

# Switch to new home setup
home-manager switch --flake .#mika

# Check what changed without applying
home-manager switch --flake .#mika --dry-run
```

### Updating Dependencies

```bash
# Update all flake inputs to latest
nix flake update

# Update specific input
nix flake update nixpkgs

# Commit lock changes
git add flake.lock
git commit -m "update: flake dependencies"
```

## Common Tasks

### Add a Package to All Systems

Edit `dendritic/features.d/packages.nix`:

```nix
cli = [
  ripgrep
  fzf
  my-new-package  # ← Add here
];
```

Then rebuild:
```bash
nix flake update
sudo nixos-rebuild switch --flake .#frame
home-manager switch --flake .#mika
```

### Enable a Feature (Wayland, X11, macOS Only)

Features are conditionally imported based on platform. Edit the relevant user home config in `dendritic/homes.d/mika-home.nix`:

```nix
imports = [
  ../features.d/packages.nix
] ++ lib.optionals (isWayland) [
  ../features.d/wayland-feature.nix
] ++ lib.optionals (!isDarwin) [
  ../features.d/linux-feature.nix
];
```

### Create New Feature Module

Create `dendritic/features.d/my-feature.nix`:

```nix
{ config, pkgs, lib, isDarwin, isWayland, ... }:
{
  programs.my-feature = {
    enable = true;
  };
  
  home.packages = lib.optionals (!isDarwin) [
    pkgs.my-package
  ];
}
```

Import in user home:
```nix
imports = [
  ../features.d/my-feature.nix
];
```

### Add New Host

1. Create hardware config: `dendritic/my-host-hardware.nix`
2. Create system config: `dendritic/my-host-config.nix`
3. Register in that file:
   ```nix
   configurations.nixos.my-host.module = ./my-host-config.nix;
   ```
4. Add to `flake.nix` imports
5. Build: `nix build .#nixosConfigurations.my-host`

See [DENDRITIC.md § Adding New Hosts](./DENDRITIC.md#adding-new-hosts) for details.

### Add New User

1. Create home config: `dendritic/homes.d/myuser-home.nix`
2. Add to host system config:
   ```nix
   users.users.myuser = {
     isNormalUser = true;
     shell = pkgs.zsh;
   };
   home-manager.users.myuser = import ./homes.d/myuser-home.nix;
   ```
3. Build and deploy: `sudo nixos-rebuild switch --flake .#frame`

See [DENDRITIC.md § Adding New Users](./DENDRITIC.md#adding-new-users) for details.

### Manage Secrets

Secrets are managed with `sops-nix`. Encrypted in `secrets.yaml`, decrypted at build time.

```bash
# Edit secrets
sops secrets.yaml

# In configuration, reference secrets
sops.secrets."my-secret" = {
  sopsFile = ../secrets.yaml;
};
```

## Key Concepts

### Dendritic Pattern

Tree-like architecture where:
- **Infrastructure** (hardware, boot, services) is the trunk
- **Features** (packages, apps, themes) are branches
- **Users** (home-manager configs) are leaves
- Everything composes at the root (flake.nix)

**Benefits**:
- DRY: Features defined once, reused everywhere
- Composable: Mix and match features per system/user
- Maintainable: Change a feature, affects all users
- Scalable: New hosts/users = simple composition

### Special Arguments

Each configuration receives context:
- `isDarwin` - Is macOS?
- `isWayland` - Is Wayland compositor?
- `hostName` - Which host?
- `inputs` - Flake inputs
- `system` - CPU architecture

Use these for platform-specific logic:
```nix
lib.optionals isDarwin [ ... ]        # macOS only
lib.optionals (!isDarwin) [ ... ]     # Linux only
lib.optionals isWayland [ ... ]       # Wayland only
lib.optionals (hostName == "frame") [ ... ]  # frame only
```

### Feature Modules

Reusable, composable configuration units:
- Packages
- Application settings
- Environment setup
- System integrations

Located in `dendritic/features.d/`. Examples:
- `packages.nix` - Categorized package sets
- `niri.nix` - Wayland compositor
- `firefox.nix` - Browser config
- `alacitty.nix` - Terminal emulator
- `theme.nix` - Visual theme

### Home-Manager Integration

User environments managed separately:
- Each user has a home config in `dendritic/homes.d/`
- Composes features for that user
- Works on Linux and macOS
- Separate from system configuration

## Directory Reference

```
config.nix/
├── dendritic/                    # Core configuration modules
│   ├── dendritic.nix            # Framework setup
│   ├── systems.nix              # Supported systems
│   ├── meta.nix                 # Global options
│   ├── nixos.nix                # NixOS builder
│   ├── darwin.nix               # Darwin builder
│   ├── home-manager.nix         # Home-manager builder
│   ├── frame-config.nix         # Frame host setup
│   ├── frame-hardware.nix       # Frame hardware
│   ├── frame-full-config.nix    # Frame complete config
│   ├── features.d/              # Reusable features
│   │   ├── packages.nix
│   │   ├── alacitty.nix
│   │   ├── firefox.nix
│   │   ├── niri.nix
│   │   ├── theme.nix
│   │   └── ...
│   └── homes.d/                 # User configurations
│       ├── mika-home.nix
│       ├── r2d2-home.nix
│       └── root-home.nix
├── hosts/                        # Hardware & infrastructure
│   ├── frame/
│   ├── server/
│   ├── mac/
│   └── vm/
├── users/                        # Legacy (being migrated)
├── flake.nix                     # Main entry point
├── flake.lock                    # Dependency lockfile
├── secrets.yaml                  # Encrypted secrets
├── .sops.yaml                    # Secrets config
├── DENDRITIC.md                  # Pattern documentation
├── MIGRATION_NOTES.md            # Migration guide
└── README.md                     # This file
```

## Workflow

### Typical Development

```bash
# Make changes
vim dendritic/features.d/packages.nix

# Test build
nix build .#nixosConfigurations.frame --dry-run

# Build
nix build .#nixosConfigurations.frame.config.system.build.toplevel

# Deploy
sudo nixos-rebuild switch --flake .#frame

# Check status
systemctl status

# If issues, rollback
sudo nixos-rebuild switch --rollback
```

### Adding Features Cross-Platform

```bash
# 1. Create feature
cat > dendritic/features.d/my-feature.nix << 'EOF'
{ config, pkgs, lib, isDarwin, ... }:
{
  home.packages = lib.optionals (!isDarwin) [
    pkgs.my-tool
  ];
}
EOF

# 2. Add to user home
vim dendritic/homes.d/mika-home.nix
# Add to imports: ../features.d/my-feature.nix

# 3. Test and deploy
nix build .#homeConfigurations.mika
home-manager switch --flake .#mika
```

### Updating Packages

```bash
# Update specific package input
nix flake update nixpkgs

# See what changed
git diff flake.lock

# Rebuild
sudo nixos-rebuild switch --flake .#frame
```

## Troubleshooting

### Build fails with "Unknown option"

**Cause**: Dendritic modules not loaded

**Fix**: Ensure `flake.nix` imports all dendritic modules

### Configuration not updating

**Cause**: Cached nix store

**Fix**: 
```bash
nix flake update
sudo nixos-rebuild switch --flake .#frame --no-link
```

### Can't find package

**Cause**: Not in package set or wrong category

**Fix**: Check `dendritic/features.d/packages.nix` and add to correct category

### Platform-specific code applying everywhere

**Cause**: Missing conditional

**Fix**: Wrap in `lib.optionals isDarwin [ ... ]` or similar

### Home-manager permissions issue

**Cause**: Files already exist

**Fix**: 
```bash
home-manager switch --flake .#mika --override-input
# Or manually remove conflicts
```

## Documentation

- **[DENDRITIC.md](./DENDRITIC.md)** - Complete pattern explanation with examples
- **[MIGRATION_NOTES.md](./MIGRATION_NOTES.md)** - Conversion guide from old structure
- **[NixOS Manual](https://nixos.org/manual/nixos/)** - Official NixOS docs
- **[Home-Manager Manual](https://nix-community.github.io/home-manager/)** - Home-manager docs
- **[Nix-Darwin](https://github.com/LnL7/nix-darwin)** - macOS configuration

## Tools Used

- **Nix** - Reproducible build system
- **NixOS** - Linux distribution
- **Nix-Darwin** - macOS configuration
- **Home-Manager** - User environment manager
- **Flakes** - Modern Nix packages
- **Flake-Parts** - Module system for flakes
- **SOPS-Nix** - Secret management

## System Details

### Frame

- **Model**: Framework 13 (7th Gen AMD)
- **OS**: NixOS Unstable
- **Kernel**: Linux with EFI boot
- **Display**: Wayland (Niri compositor)
- **Users**: mika, r2d2

### Mac

- **Model**: MacBook (ARM64)
- **OS**: macOS via Nix-Darwin
- **Architecture**: aarch64-darwin
- **Users**: mika

### Server

- **OS**: NixOS
- **Architecture**: x86_64-linux
- **Users**: root (headless)

## Getting Help

1. **Pattern questions**: Read [DENDRITIC.md](./DENDRITIC.md)
2. **Migration help**: See [MIGRATION_NOTES.md](./MIGRATION_NOTES.md)
3. **NixOS issues**: Check [nixos.org](https://nixos.org)
4. **Home-Manager**: Visit [nix-community.github.io/home-manager](https://nix-community.github.io/home-manager/)
5. **Code examples**: Look in `dendritic/homes.d/` and `dendritic/features.d/`

## Contributing

When adding new features or hosts:

1. Follow the dendritic pattern (see [DENDRITIC.md](./DENDRITIC.md))
2. Keep features in `dendritic/features.d/`
3. Use platform-aware conditionals (`isDarwin`, `isWayland`, etc.)
4. Document complex setups in feature file comments
5. Test on both Linux and macOS if possible
6. Commit with clear messages

## License

Personal dotfiles configuration - modify as needed for your setup

---

**Version**: 2024-05 (Dendritic Pattern)  
**Last Updated**: 2024  
**Branch**: main (legacy: dendritic-refactor)
