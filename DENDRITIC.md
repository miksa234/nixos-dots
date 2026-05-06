# The Dendritic Pattern

This configuration uses the **dendritic pattern** for NixOS and Nix-Darwin management, a modular architecture that enables organizing configurations across multiple systems, users, and feature sets in a clean, scalable way.

## Table of Contents

1. [Overview](#overview)
2. [Why Dendritic?](#why-dendritic)
3. [Core Concepts](#core-concepts)
4. [Directory Structure](#directory-structure)
5. [Module Types](#module-types)
6. [How It Works](#how-it-works)
7. [Adding New Features](#adding-new-features)
8. [Adding New Hosts](#adding-new-hosts)
9. [Adding New Users](#adding-new-users)
10. [Cross-Platform Features](#cross-platform-features)
11. [Examples](#examples)

## Overview

The dendritic pattern is a tree-like modular architecture for Nix configurations. Instead of organizing by OS or host (host-centric), we organize by **what** we want to configure:

- **Infrastructure modules**: Hardware, boot, networking, services
- **Feature modules**: Composable units of functionality (theme, editor config, window manager)
- **User modules**: Per-user configurations managed by home-manager
- **System definitions**: Combine infrastructure + features + users for specific hosts

This approach creates a "dendritic" (tree-like) structure where:
- Core system concerns branch out from infrastructure
- User environments branch out from home-manager
- Features are leaves that can be attached to any branch
- Everything flows together at the root (flake.nix)

## Why Dendritic?

### Advantages over Host-Centric Approach

**Old approach (host-centric):**
```
hosts/
  ├── frame/configuration.nix       # monolithic, specific to frame
  ├── server/configuration.nix      # monolithic, specific to server
  └── mac/configuration.nix         # monolithic, specific to mac
```

Problems:
- 🔴 Duplication: Common features repeated in each host config
- 🔴 Maintenance: Change one thing, update three places
- 🔴 Reusability: Hard to share configs across systems
- 🔴 Scalability: New hosts mean new monolithic files
- 🔴 Testing: No easy way to test features in isolation

**New approach (dendritic):**
```
dendritic/
  ├── nixos.nix                     # OS-specific setup
  ├── darwin.nix                    # OS-specific setup
  ├── home-manager.nix              # User environment setup
  ├── features.d/                   # Composable features
  │   ├── packages.nix              # Package sets
  │   ├── niri.nix                  # Wayland compositor
  │   ├── theme.nix                 # Visual theme
  │   └── ...
  ├── homes.d/                      # User environments
  │   ├── mika-home.nix
  │   ├── r2d2-home.nix
  │   └── root-home.nix
  └── frame-config.nix              # Compose for frame host
```

Advantages:
- ✅ **DRY**: Each feature defined once, used everywhere
- ✅ **Composable**: Mix and match features for different systems
- ✅ **Maintainable**: Change a feature once, affects all users
- ✅ **Scalable**: Add new hosts by composing existing pieces
- ✅ **Testable**: Test features in isolation or combinations
- ✅ **Cross-platform**: Same features work on Linux and macOS

## Core Concepts

### 1. **Module Registry System**

Configurations are registered in the flake root using options:

```nix
configurations.nixos.<name>.module = ./path/to/config.nix
configurations.darwin.<name>.module = ./path/to/config.nix
configurations.homeManager.<name>.module = ./path/to/config.nix
```

The dendritic framework automatically:
- Discovers all registered configurations
- Builds them into flake outputs
- Passes special args (`isDarwin`, `isWayland`, `hostName`, etc.)

### 2. **Special Arguments**

Each system receives context via special args:

```nix
# NixOS systems
specialArgs = {
  inherit inputs;
  hostName = "frame";           # The configuration name
  isDarwin = false;              # Platform flag
  isWayland = config.isWayland;  # UI platform flag
};

# Darwin systems
specialArgs = {
  inherit inputs;
  system = config.darwinSystem;
};

# Home-manager
extraSpecialArgs = {
  inherit system inputs;
  isDarwin = system == config.darwinSystem;
};
```

### 3. **Feature Selection**

Features are conditionally imported based on:
- **Platform**: `isDarwin`, `isLinux`
- **UI platform**: `isWayland`, `isX11`
- **Host**: `hostName` matches
- **User**: explicit user configuration

Example:
```nix
imports = [
  ../modules/firefox.nix
  (import ../modules/alacitty.nix { inherit isDarwin; })
]
++ lib.optionals (!isDarwin) [
  ../modules/theme.nix
  ../modules/xdg.nix
]
++ lib.optionals (isWayland) [
  ../modules/niri.nix
  ../modules/noctalia.nix
];
```

## Directory Structure

```
config.nix/
├── dendritic/                           # Core dendritic modules
│   ├── dendritic.nix                    # Enable flake-parts modules
│   ├── systems.nix                      # Supported systems (x86_64-linux, aarch64-darwin)
│   ├── meta.nix                         # Global options (username, hostNames, domain, etc.)
│   ├── nixos.nix                        # NixOS system builder
│   ├── darwin.nix                       # nix-darwin system builder
│   ├── home-manager.nix                 # home-manager configuration builder
│   │
│   ├── features.d/                      # Feature modules (cross-platform, reusable)
│   │   ├── packages.nix                 # Categorized package sets
│   │   ├── alacitty.nix                 # Terminal emulator config
│   │   ├── firefox.nix                  # Browser configuration
│   │   ├── niri.nix                     # Wayland compositor config
│   │   ├── noctalia.nix                 # Shell environment (Wayland)
│   │   ├── theme.nix                    # Visual theme (Linux)
│   │   ├── xdg.nix                      # XDG base directories (Linux)
│   │   ├── dotfiles.nix                 # Dotfile linking
│   │   ├── nix-settings.nix             # Nix configuration
│   │   ├── systemd-services.nix         # User systemd services
│   │   └── nm.nix                       # Network manager config
│   │
│   ├── homes.d/                         # User environments
│   │   ├── mika-home.nix                # Mika's home-manager config
│   │   ├── r2d2-home.nix                # R2D2's home-manager config
│   │   └── root-home.nix                # Root's home-manager config
│   │
│   ├── frame-config.nix                 # Frame host configuration
│   ├── frame-full-config.nix            # Frame NixOS with all imports
│   ├── frame-hardware.nix               # Frame hardware config
│   │
│   └── meta.nix                         # Configuration options
│
├── hosts/                               # Legacy host configurations (being phased out)
│   ├── frame/
│   ├── server/
│   ├── mac/
│   └── vm/
│
├── users/                               # Legacy user configurations (being phased out)
│   ├── mika.nix
│   ├── r2d2.nix
│   └── root.nix
│
├── flake.nix                            # Main flake entry point
├── flake.lock                           # Lockfile
└── secrets.yaml                         # Encrypted secrets (sops-nix)
```

## Module Types

### 1. Infrastructure Modules

Located in `dendritic/` and `hosts/`, these define system-level configuration:

**Purpose**: Hardware, boot, services, networking, system packages

**Example: frame-hardware.nix**
```nix
{ config, inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];
  
  boot.loader.systemd-boot.enable = true;
  networking.hostName = "frame";
  # ...
}
```

**Example: frame-full-config.nix**
Combines infrastructure with features:
```nix
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./frame-hardware.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];
  
  # System configuration
  system.stateVersion = "26.05";
  networking.hostName = "frame";
  
  # Home-manager integration
  home-manager.users.mika = import ./homes.d/mika-home.nix;
  home-manager.users.root = import ./homes.d/root-home.nix;
}
```

### 2. Feature Modules

Located in `dendritic/features.d/`, these are composable, reusable configurations:

**Purpose**: Package collections, application configs, UI tweaks, system integrations

**Key characteristics**:
- Platform-aware (check `isDarwin`, `isWayland`)
- Single responsibility (one feature per file)
- Parametric (accept config/pkgs/lib/etc.)
- No side effects outside their scope

**Example: packages.nix**
```nix
{ pkgs, isDarwin }:
{
  system = [ home-manager nix just ];
  shell = [ zsh tmux neovim ];
  wayland = [ swaybg swaylock fuzzel ];
  cli = [ ripgrep fzf bat ];
  development = [ nodejs python3 rustup ];
  # ...
}
```

**Example: niri.nix** (Wayland compositor)
```nix
{ config, pkgs, lib, inputs, ... }:
{
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.system}.niri;
  };
  
  services.niri.enable = true;
  
  home.packages = [ inputs.niri.packages.${pkgs.system}.niri-session ];
}
```

### 3. User Modules

Located in `dendritic/homes.d/`, these define per-user home-manager configurations:

**Purpose**: User packages, dotfiles, user services, user-specific features

**Structure**:
```nix
{ config, pkgs, lib, inputs, isDarwin, isWayland, ... }:
{
  nixpkgs.config.allowUnfree = true;
  
  home.username = "mika";
  home.stateVersion = "26.05";
  home.packages = [ ... ];
  
  home.file = { ... };
  home.sessionVariables = { ... };
  
  imports = [
    ../features.d/dotfiles.nix
    ../features.d/packages.nix
  ] ++ lib.optionals (!isDarwin) [
    ../features.d/theme.nix
  ];
}
```

### 4. System Definitions

Located in `dendritic/`, these compose infrastructure + features for specific hosts:

**Example: frame-config.nix**
```nix
{ config, inputs, ... }:
{
  configurations.nixos.frame.module = ./frame-full-config.nix;
}
```

## How It Works

### Build Flow

1. **flake.nix** loads dendritic modules:
   ```nix
   outputs = inputs:
     inputs.flake-parts.lib.mkFlake { inherit inputs; } {
       imports = [
         ./dendritic/dendritic.nix
         ./dendritic/systems.nix
         ./dendritic/meta.nix
         ./dendritic/nixos.nix
         ./dendritic/darwin.nix
         ./dendritic/home-manager.nix
         ./dendritic/frame-config.nix
       ];
     };
   ```

2. **dendritic modules** register configurations:
   ```nix
   # nixos.nix discovers all configurations.nixos.* and builds them
   config.flake.nixosConfigurations = {
     frame = nixpkgs.lib.nixosSystem { ... };
     server = nixpkgs.lib.nixosSystem { ... };
   };
   ```

3. **Special arguments** pass context:
   ```nix
   specialArgs = {
     inherit inputs;
     hostName = "frame";
     isDarwin = false;
     isWayland = config.isWayland;
   };
   ```

4. **Module imports** apply platform-specific features:
   ```nix
   imports = [
     ./features.d/packages.nix
   ] ++ lib.optionals (isWayland) [
     ./features.d/niri.nix
   ];
   ```

5. **Flake output** produces buildable configurations:
   ```bash
   flake.nixosConfigurations.frame    # NixOS for frame
   flake.darwinConfigurations.mac     # macOS for mac
   flake.homeConfigurations.mika      # home-manager for mika
   ```

### Building Configurations

```bash
# Build NixOS system
nix build .#nixosConfigurations.frame.config.system.build.toplevel
nixos-rebuild switch --flake .#frame

# Build macOS system
nix build .#darwinConfigurations.mac
darwin-rebuild switch --flake .#mac

# Build home-manager
nix build .#homeConfigurations.mika.activationPackage
home-manager switch --flake .#mika
```

## Adding New Features

### Step 1: Create Feature Module

Create `dendritic/features.d/my-feature.nix`:

```nix
{ config, pkgs, lib, isDarwin, isWayland, ... }:
{
  # Feature configuration
  programs.my-feature = {
    enable = true;
  };
  
  # Platform-specific settings
  home.packages = lib.optionals (!isDarwin) [
    pkgs.my-package
  ];
  
  # User files/config
  xdg.configFile."myapp/config".text = ''
    [settings]
    option = value
  '';
}
```

### Step 2: Import in Target Configuration

Add to user home config (`homes.d/mika-home.nix`):

```nix
imports = [
  ../features.d/my-feature.nix
];
```

Or conditionally:

```nix
imports = [
  ../features.d/packages.nix
] ++ lib.optionals (isWayland) [
  ../features.d/my-feature.nix
];
```

### Step 3: Test

```bash
# Test build
nix build .#homeConfigurations.mika

# Activate (or check with `--dry-run`)
home-manager switch --flake .#mika
```

## Adding New Hosts

### Step 1: Create Hardware Configuration

Create `dendritic/my-host-hardware.nix`:

```nix
{ config, lib, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "my-host";
  time.timeZone = "UTC";
  
  # Hardware-specific packages and settings
  services.openssh.enable = true;
}
```

### Step 2: Create System Configuration

Create `dendritic/my-host-config.nix`:

```nix
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./my-host-hardware.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  
  system.stateVersion = "26.05";
  
  # System-level settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Home-manager for users
  home-manager.users.mika = import ./homes.d/mika-home.nix;
}
```

### Step 3: Register Configuration

Edit `dendritic/my-host-config.nix` (or create similar):

```nix
{ config, inputs, ... }:
{
  configurations.nixos.my-host.module = ./my-host-config.nix;
}
```

### Step 4: Update Flake

Add to `flake.nix` imports:

```nix
imports = [
  ./dendritic/dendritic.nix
  ./dendritic/systems.nix
  ./dendritic/meta.nix
  ./dendritic/nixos.nix
  ./dendritic/darwin.nix
  ./dendritic/home-manager.nix
  ./dendritic/frame-config.nix
  ./dendritic/my-host-config.nix  # ← Add this
];
```

### Step 5: Update Meta

If adding to `meta.nix`, update `hostNames`:

```nix
hostNames = lib.mkOption {
  type = lib.types.attrsOf lib.types.str;
  default = {
    frame = "frame";
    server = "server";
    mac = "mac";
    my-host = "my-host";  # ← Add this
  };
};
```

### Step 6: Build and Deploy

```bash
# Build the new system
nix build .#nixosConfigurations.my-host

# Test build (if VM)
nix build .#nixosConfigurations.my-host.config.system.build.vm

# Deploy
nixos-rebuild switch --flake .#my-host
```

## Adding New Users

### Step 1: Create User Home Configuration

Create `dendritic/homes.d/my-user-home.nix`:

```nix
{ config, pkgs, lib, inputs, isDarwin, isWayland, ... }:
{
  home = {
    username = "my-user";
    stateVersion = if isDarwin then "25.11" else "26.05";
  };
  
  # User packages
  home.packages = with pkgs; [
    vim
    git
  ];
  
  # User environment
  home.sessionVariables = {
    EDITOR = "vim";
  };
  
  # Import features
  imports = [
    ../features.d/alacitty.nix
    ../features.d/firefox.nix
  ] ++ lib.optionals (!isDarwin) [
    ../features.d/theme.nix
  ];
}
```

### Step 2: Add to Host Configuration

Edit the relevant host config (e.g., `dendritic/frame-full-config.nix`):

```nix
home-manager.users = {
  mika = import ./homes.d/mika-home.nix;
  r2d2 = import ./homes.d/r2d2-home.nix;
  my-user = import ./homes.d/my-user-home.nix;  # ← Add this
};
```

### Step 3: Create System User

Add to NixOS system config:

```nix
users.users.my-user = {
  isNormalUser = true;
  description = "My User";
  extraGroups = [ "wheel" ];
  shell = pkgs.zsh;
};
```

### Step 4: Test and Deploy

```bash
# Build
nix build .#nixosConfigurations.frame

# Deploy
nixos-rebuild switch --flake .#frame
```

## Cross-Platform Features

### Creating Platform-Aware Features

Use conditional imports and parameters:

```nix
# features.d/universal-feature.nix
{ config, pkgs, lib, isDarwin, isWayland, hostName, ... }:
let
  # Platform-specific package selection
  basePackages = with pkgs; [ vim git ];
  linuxPackages = with pkgs; [ libnotify ];
  darwinPackages = with pkgs; [ ];
  
in
{
  # Conditional services
  services.my-service = lib.mkIf (!isDarwin) {
    enable = true;
  };
  
  # Platform-specific packages
  home.packages = basePackages
    ++ lib.optionals (!isDarwin) linuxPackages
    ++ lib.optionals isDarwin darwinPackages;
  
  # Conditional imports
  imports = lib.optionals (!isDarwin) [
    ./linux-specific-feature.nix
  ];
}
```

### Common Patterns

**Check for Linux:**
```nix
lib.optionals (!isDarwin) [ ... ]
```

**Check for macOS:**
```nix
lib.optionals isDarwin [ ... ]
```

**Check for Wayland:**
```nix
lib.optionals isWayland [ ... ]
```

**Check for X11:**
```nix
lib.optionals (!isWayland) [ ... ]
```

**Check for specific host:**
```nix
lib.optionals (hostName == "frame") [ ... ]
```

### Example: Firefox Configuration

```nix
# features.d/firefox.nix
{ config, pkgs, lib, isDarwin, inputs, ... }:
{
  programs.firefox = {
    enable = true;
    
    # Platform-specific home
    profiles.default = lib.mkIf (!isDarwin) {
      bookmarks = [ ... ];
      settings = { ... };
    };
  };
  
  # macOS-specific extensions would go here
  home.packages = lib.optionals isDarwin [
    pkgs.firefox
  ];
}
```

## Examples

### Example 1: Add a New Package to All Systems

Add to `features.d/packages.nix`:

```nix
{ pkgs, isDarwin }:
{
  # ...
  cli = [
    ripgrep
    fzf
    my-new-package  # ← Add here
  ];
  # ...
}
```

Build and test:
```bash
nix flake update
nix build .#nixosConfigurations.frame
home-manager switch --flake .#mika
```

### Example 2: Add Platform-Specific Feature

Create `dendritic/features.d/wayland-only.nix`:

```nix
{ config, pkgs, lib, ... }:
{
  wayland.windowManager.sway.enable = true;
  
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
  };
}
```

Import conditionally in user config:

```nix
imports = [
  ../features.d/alacitty.nix
] ++ lib.optionals (isWayland) [
  ../features.d/wayland-only.nix
];
```

### Example 3: Create Specialized Feature Set

Create `dendritic/features.d/development.nix`:

```nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    git
    gh
    nodejs
    python3
    rustup
    cargo
  ];
  
  programs.git = {
    enable = true;
    userName = "My Name";
    userEmail = "me@example.com";
  };
  
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
```

Add to user that needs it:

```nix
imports = [
  ../features.d/alacitty.nix
  ../features.d/development.nix
];
```

## Migration from Old Structure

See [MIGRATION_NOTES.md](./MIGRATION_NOTES.md) for details on converting from the old host-centric structure to dendritic.

## Resources

- [Flake Parts Documentation](https://flake.parts)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix-Darwin](https://github.com/LnL7/nix-darwin)

## Troubleshooting

**Issue**: Configuration doesn't update after changes
- **Solution**: Run `nix flake update` to refresh lockfile, then rebuild

**Issue**: Platform-specific settings being applied everywhere
- **Solution**: Check that conditionals use `isDarwin`, `isWayland`, etc. correctly

**Issue**: User package sets not appearing
- **Solution**: Ensure user home config imports feature modules correctly

**Issue**: Home-manager conflicts with system packages
- **Solution**: Manage each package in only one place (system or user, not both)

---

Last updated: 2024
Pattern: Dendritic (tree-like, modular Nix configuration)
