# Migration Notes: Host-Centric to Dendritic Pattern

This document explains the changes made during the migration from the traditional host-centric configuration structure to the modern dendritic (tree-like, modular) pattern.

## Table of Contents

1. [Overview of Changes](#overview-of-changes)
2. [Directory Structure Changes](#directory-structure-changes)
3. [Files Moved/Reorganized](#files-movedreorganized)
4. [Breaking Changes](#breaking-changes)
5. [API Changes](#api-changes)
6. [How to Convert Old Modules](#how-to-convert-old-modules)
7. [Build Command Changes](#build-command-changes)
8. [Troubleshooting Migration Issues](#troubleshooting-migration-issues)

## Overview of Changes

### What Changed

The configuration was restructured from a **host-centric** (one file per host) to a **dendritic** (feature-based, composable) architecture.

**Old Model:**
```
Each host has its own monolithic configuration file
hosts/frame/configuration.nix ← All frame config in one file
```

**New Model:**
```
Features are defined once and composed across hosts
dendritic/features.d/ ← Reusable feature modules
  ├── packages.nix
  ├── niri.nix
  ├── theme.nix
  └── ...
dendritic/frame-config.nix ← Frame composes features
```

### Why This Change

- **Reduced Duplication**: Common features not repeated per-host
- **Easier Maintenance**: Change a feature once, affects all systems
- **Better Composability**: Share configurations across platforms
- **Cleaner Structure**: Separation of concerns (infrastructure, features, users)
- **Future Scalability**: Adding new hosts/users is simple composition

## Directory Structure Changes

### Old Structure
```
config.nix/
├── hosts/
│   ├── frame/
│   │   ├── configuration.nix    (500+ lines, everything mixed)
│   │   ├── hardware.nix
│   │   └── disk.nix
│   ├── server/
│   │   ├── configuration.nix    (monolithic)
│   │   ├── hardware.nix
│   │   └── disk.nix
│   └── mac/
│       └── configuration.nix    (monolithic)
├── users/
│   ├── mika.nix                 (user settings)
│   ├── r2d2.nix
│   └── root.nix
└── flake.nix                    (manually wired everything)
```

### New Structure
```
config.nix/
├── dendritic/                           (NEW: Core pattern modules)
│   ├── dendritic.nix                   (Enables flake-parts)
│   ├── systems.nix                     (Supported platforms)
│   ├── meta.nix                        (Global options)
│   ├── nixos.nix                       (NixOS builder)
│   ├── darwin.nix                      (Darwin builder)
│   ├── home-manager.nix                (Home-manager builder)
│   ├── features.d/                     (NEW: Composable features)
│   │   ├── packages.nix
│   │   ├── alacitty.nix
│   │   ├── firefox.nix
│   │   ├── niri.nix                    (from homes.d/)
│   │   ├── noctalia.nix                (from homes.d/)
│   │   ├── theme.nix                   (from homes.d/)
│   │   ├── xdg.nix                     (from homes.d/)
│   │   ├── dotfiles.nix                (from homes.d/)
│   │   ├── nix-settings.nix            (from homes.d/)
│   │   ├── systemd-services.nix        (from homes.d/)
│   │   └── nm.nix                      (from homes.d/)
│   ├── homes.d/                        (NEW: User environments)
│   │   ├── mika-home.nix               (composes features)
│   │   ├── r2d2-home.nix
│   │   └── root-home.nix
│   ├── frame-config.nix                (Host composer)
│   ├── frame-hardware.nix              (from hosts/frame/)
│   ├── frame-full-config.nix           (host + features)
│   └── meta.nix                        (configuration options)
├── hosts/                              (DEPRECATED: Legacy, being phased out)
│   └── (old structure preserved for reference)
├── users/                              (DEPRECATED: Legacy, being phased out)
│   └── (old structure preserved for reference)
└── flake.nix                           (now uses dendritic modules)
```

## Files Moved/Reorganized

### Infrastructure Files

| Old Location | New Location | Notes |
|---|---|---|
| `hosts/frame/hardware.nix` | `dendritic/frame-hardware.nix` | Hardware config unchanged |
| `hosts/frame/configuration.nix` | Split across multiple files | Now composed from features |
| `hosts/frame/configuration.nix` → services | `dendritic/frame-full-config.nix` | Services and system setup |
| `hosts/frame/configuration.nix` → users | `dendritic/homes.d/` | User configs now separate |

### Feature Files

| Old Location | New Location | Change |
|---|---|---|
| Scattered in `hosts/frame/configuration.nix` | `dendritic/features.d/packages.nix` | Package definitions extracted |
| Scattered in `hosts/frame/configuration.nix` | `dendritic/features.d/niri.nix` | Wayland compositor config |
| Scattered in `hosts/frame/configuration.nix` | `dendritic/features.d/theme.nix` | Theme settings |
| Scattered in `hosts/frame/configuration.nix` | `dendritic/features.d/xdg.nix` | XDG base directories |

### User Files

| Old Location | New Location | Notes |
|---|---|---|
| `users/mika.nix` (system level) | `dendritic/homes.d/mika-home.nix` | Now uses home-manager |
| `users/r2d2.nix` (system level) | `dendritic/homes.d/r2d2-home.nix` | Now uses home-manager |
| `users/root.nix` (system level) | `dendritic/homes.d/root-home.nix` | Now uses home-manager |

### Flake Changes

| File | Change |
|---|---|
| `flake.nix` | Now imports dendritic modules instead of manually wiring configs |
| `flake.nix` | Automatically discovers configurations via options system |

## Breaking Changes

### 1. Configuration Registry System

**Old way:**
```nix
# flake.nix - manual wiring
outputs = { self, nixpkgs, nixos-hardware, ... }:
{
  nixosConfigurations.frame = nixpkgs.lib.nixosSystem {
    modules = [ ./hosts/frame/configuration.nix ];
  };
};
```

**New way:**
```nix
# dendritic/nixos.nix - automatic discovery
configurations.nixos.frame.module = ./frame-full-config.nix;
# Framework handles the rest
```

**Migration impact**: Configurations must use `configurations.<platform>.<name>.module`

### 2. Special Arguments

**Old way:**
```nix
# Manually passed, inconsistent
specialArgs = { isDarwin = false; };
```

**New way:**
```nix
# Automatically provided by framework
specialArgs = {
  inherit inputs;
  hostName = "frame";
  isDarwin = false;
  isWayland = config.isWayland;
};
```

**Migration impact**: Modules can rely on standard special args

### 3. User Configuration Location

**Old way:**
```nix
# In main configuration.nix
users.users.mika = { ... };
home-manager.users.mika = { ... };  # Mixed with system config
```

**New way:**
```nix
# In hosts/frame/configuration.nix
home-manager.users.mika = import ./homes.d/mika-home.nix;

# In dendritic/homes.d/mika-home.nix
{ config, pkgs, lib, isDarwin, isWayland, ... }:
{
  # User config isolated here
}
```

**Migration impact**: User configs must be in separate `homes.d/` files

### 4. Feature Imports

**Old way:**
```nix
# Everything inline in configuration.nix
programs.niri = { enable = true; };
theme.colors = { ... };
xdg.configHome = "/home/mika/.config";
```

**New way:**
```nix
# In homes.d/mika-home.nix
imports = [
  ../features.d/niri.nix
  ../features.d/theme.nix
  ../features.d/xdg.nix
];
```

**Migration impact**: Features must be extracted to separate module files

### 5. Build/Deployment Commands

**Old way:**
```bash
sudo nixos-rebuild switch -I nixos-config=./hosts/frame/configuration.nix
```

**New way:**
```bash
sudo nixos-rebuild switch --flake .#frame
```

**Migration impact**: Flake references replace explicit file paths

## API Changes

### Configuration Options

#### Old: Direct Configuration
```nix
{ config, pkgs, ... }:
{
  system.stateVersion = "25.05";
  networking.hostName = "frame";
}
```

#### New: Through Framework
```nix
# Meta options (dendritic/meta.nix)
options = {
  username = lib.mkOption { default = "mika"; };
  hostNames = lib.mkOption { default = { frame = "frame"; }; };
  isWayland = lib.mkOption { default = builtins.getEnv "IS_WAYLAND" == "1"; };
};
```

### Platform-Aware Conditionals

#### Old: Manual Checks
```nix
stdenv.lib.optionals stdenv.isDarwin [ ... ]
```

#### New: Standard Arguments
```nix
lib.optionals isDarwin [ ... ]
lib.optionals (isWayland) [ ... ]
lib.optionals (hostName == "frame") [ ... ]
```

### Home-Manager Integration

#### Old: Built into NixOS Config
```nix
{ config, ... }:
{
  home-manager.users.mika = {
    home.packages = [ ... ];
  };
}
```

#### New: Separate Registration
```nix
# dendritic/frame-full-config.nix
home-manager.users.mika = import ./homes.d/mika-home.nix;

# dendritic/homes.d/mika-home.nix
{ config, pkgs, lib, isDarwin, ... }:
{
  home.packages = [ ... ];
}
```

## How to Convert Old Modules

### Step 1: Identify the Module Type

Determine if it's infrastructure, feature, or user config:

```
Infrastructure (system-level):
  - Boot configuration
  - Networking
  - System services
  - Hardware setup
  
Feature (composable, reusable):
  - Application configs
  - Package sets
  - UI themes
  - Development tools
  
User (home-manager):
  - User packages
  - User programs
  - Dotfiles
  - User services
```

### Step 2: Extract to Appropriate Directory

**For Infrastructure:**
```bash
# Old
hosts/frame/configuration.nix (scattered system config)

# New
dendritic/frame-full-config.nix  (system setup)
dendritic/frame-hardware.nix     (hardware-specific)
```

**For Features:**
```bash
# Old
Inside hosts/frame/configuration.nix:
  services.niri = ...
  theme = ...

# New
dendritic/features.d/niri.nix
dendritic/features.d/theme.nix
```

**For Users:**
```bash
# Old
users/mika.nix (system-level user config)

# New
dendritic/homes.d/mika-home.nix (home-manager config)
```

### Step 3: Template for Feature Extraction

**Example: Extract Theme Feature**

**Old (in hosts/frame/configuration.nix):**
```nix
{ config, lib, pkgs, ... }:
{
  # ... 500 other lines ...
  
  home-manager.users.mika = {
    qt = {
      enable = true;
      style.name = "breeze-dark";
    };
    gtk = {
      enable = true;
      theme.name = "Breeze-Dark";
    };
  };
  
  # ... more config ...
}
```

**New (dendritic/features.d/theme.nix):**
```nix
{ config, lib, pkgs, ... }:
{
  qt = {
    enable = true;
    style.name = "breeze-dark";
  };
  
  gtk = {
    enable = true;
    theme.name = "Breeze-Dark";
  };
}
```

**Then import in user home:**
```nix
# dendritic/homes.d/mika-home.nix
imports = [
  ../features.d/theme.nix
];
```

### Step 4: Handle Platform-Specific Code

**Pattern: Linux-Only Service**

```nix
# Old (mixed in configuration.nix)
{ lib, pkgs, ... }:
{
  services.some-linux-service = {
    enable = true;
  };
}
```

**New (feature with conditionals):**
```nix
# dendritic/features.d/linux-service.nix
{ config, lib, pkgs, isDarwin, ... }:
{
  services.some-linux-service = lib.mkIf (!isDarwin) {
    enable = true;
  };
}
```

**Then conditionally import:**
```nix
# dendritic/homes.d/mika-home.nix or frame-full-config.nix
imports = [
  ../features.d/linux-service.nix
] ++ lib.optionals (!isDarwin) [
  ../features.d/linux-only-feature.nix
];
```

### Step 5: Update Imports Chain

From breaking down one large file to composing many:

**Before:**
```nix
# hosts/frame/configuration.nix (single import)
{ config, ... }:
{
  imports = [
    ./hardware.nix
  ];
  # 500+ lines of config
}
```

**After:**
```nix
# dendritic/frame-full-config.nix (composed from features)
{ config, ... }:
{
  imports = [
    ./frame-hardware.nix
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
  ];
  
  # Only host-specific setup here
  system.stateVersion = "26.05";
  
  # Users import their own features
  home-manager.users.mika = import ./homes.d/mika-home.nix;
  home-manager.users.r2d2 = import ./homes.d/r2d2-home.nix;
}

# dendritic/homes.d/mika-home.nix (user composes features)
{ config, pkgs, lib, isDarwin, isWayland, ... }:
{
  imports = [
    ../features.d/packages.nix
    ../features.d/alacitty.nix
    ../features.d/firefox.nix
  ] ++ lib.optionals (!isDarwin) [
    ../features.d/theme.nix
    ../features.d/xdg.nix
  ] ++ lib.optionals (isWayland) [
    ../features.d/niri.nix
  ];
}
```

## Build Command Changes

### System Building

**Old:**
```bash
# Explicit file path
sudo nixos-rebuild switch -I nixos-config=./hosts/frame/configuration.nix

# Or with flakes (manual)
nix flake update
nix build .#nixosConfigurations.frame.config.system.build.toplevel
sudo nixos-rebuild switch --flake .#frame
```

**New:**
```bash
# Flake is primary
nix flake update
sudo nixos-rebuild switch --flake .#frame
```

### Home-Manager

**Old:**
```bash
# System user config then home-manager separately
home-manager switch -f ./users/mika.nix
```

**New:**
```bash
# Flake-integrated
home-manager switch --flake .#mika
```

### Testing

**Old:**
```bash
# Manual path specification
nix build -f ./hosts/frame/configuration.nix
```

**New:**
```bash
# Automatic discovery
nix build .#nixosConfigurations.frame.config.system.build.toplevel
```

## Troubleshooting Migration Issues

### Issue: "Unknown option configuration.nixos"

**Cause**: Dendritic modules not imported

**Solution**: Ensure `flake.nix` imports dendritic modules:
```nix
imports = [
  ./dendritic/dendritic.nix
  ./dendritic/systems.nix
  ./dendritic/meta.nix
  ./dendritic/nixos.nix
  ./dendritic/darwin.nix
  ./dendritic/home-manager.nix
];
```

### Issue: "Special args not available (isDarwin, isWayland)"

**Cause**: Using old pattern without special args

**Solution**: Ensure module receives special args in its function signature:
```nix
{ config, pkgs, lib, isDarwin, isWayland, hostName, ... }:
```

### Issue: Features not being imported

**Cause**: Conditional import or wrong path

**Check**:
1. Feature exists at path
2. Correct relative import path `../features.d/feature.nix`
3. Conditional import if checking `isDarwin`, `isWayland`, etc.

### Issue: Home-manager user not found

**Cause**: User not registered in host config

**Solution**: Add to host configuration:
```nix
# dendritic/frame-full-config.nix
home-manager.users.myuser = import ./homes.d/myuser-home.nix;
```

Also create system user:
```nix
users.users.myuser = {
  isNormalUser = true;
  shell = pkgs.zsh;
};
```

### Issue: Packages appearing in wrong user/host

**Cause**: Duplicate definitions or wrong import

**Solution**: 
1. Define packages once, in one place
2. Use feature modules to share
3. Don't repeat in multiple homes.d/

## Backward Compatibility

### Old Structure Still Exists

The old `hosts/` and `users/` directories remain for reference but are **deprecated**. They are not used by the new system.

### Gradual Migration

Can migrate one host at a time:
1. Keep `hosts/` structure for inactive hosts
2. Convert and migrate one host to `dendritic/` pattern
3. Test thoroughly
4. Migrate remaining hosts
5. Remove old directories once complete

## Quick Cheat Sheet

| Task | Old Way | New Way |
|---|---|---|
| Add package to all systems | Edit each host config | Add to `features.d/packages.nix` |
| Create new host | Copy `hosts/old/configuration.nix` | Create `dendritic/new-config.nix` and register |
| Build system | `nixos-rebuild switch -I nixos-config=...` | `nixos-rebuild switch --flake .#hostname` |
| Test configuration | Manual build | `nix build .#nixosConfigurations.hostname` |
| Share config across hosts | Copy-paste | Create feature, import in multiple hosts |
| Platform-specific code | Manual checks | Use `isDarwin`, `isWayland` special args |

## Resources for Converting Old Modules

- See [DENDRITIC.md](./DENDRITIC.md) for pattern details
- Check `dendritic/features.d/*.nix` for examples
- Review `dendritic/homes.d/*.nix` for user composition patterns

---

**Migration Status**: Complete for frame host, server and mac still using legacy structure

**Last Updated**: 2024
