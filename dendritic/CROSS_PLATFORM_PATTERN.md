# Cross-Platform Configuration Pattern

## Overview

The dendritic pattern supports creating infrastructure modules that work across multiple platforms without duplication. This document explains how to create a cross-platform feature that works with NixOS, nix-darwin (macOS), and home-manager.

## The Problem

Different platforms have different configuration systems:
- **NixOS**: System-level configuration via `configuration.nix`
- **nix-darwin**: macOS system configuration
- **home-manager**: User-level configuration (works on Linux and macOS)

Each has different module systems and option structures, requiring separate implementations for the same feature.

## The Solution: Context Detection

The cross-platform pattern uses **runtime context detection** instead of build-time specialArgs to determine which module system is active. This allows a single module to support multiple contexts.

### Key Detection Methods

#### 1. Home-Manager Detection
```nix
isHomeManager = config ? home;
```

Check if the `config` object contains a `home` attribute:
- **True**: Running in home-manager context
- **False**: Running in NixOS or nix-darwin context

This works because:
- home-manager adds `config.home` with user-level configuration
- NixOS and nix-darwin don't have this attribute

#### 2. Platform Detection
```nix
isDarwin = builtins.currentSystem == "aarch64-darwin" 
        || builtins.currentSystem == "x86_64-darwin";
```

Detect the platform:
- **True**: Running on macOS (Darwin)
- **False**: Running on Linux

#### 3. Other Detection Methods
```nix
# Check if a specific program is enabled
config.programs.zsh.enable

# Check for specific attributes
config ? systemd  # NixOS-specific

# Use hasAttr for safe attribute checking
lib.hasAttr "home" config
```

## Implementation Pattern

### 1. Define Shared Configuration
Extract common settings into let-bindings:

```nix
let
  gitConfig = {
    user = { name = "Name"; email = "email@example.com"; };
    core = { editor = "nvim"; };
  };
  
  shellAliases = {
    "ga" = "git add";
    "gc" = "git commit";
  };
in
# ... rest of module
```

### 2. Use Conditional Merging
Apply different configurations based on context:

```nix
lib.mkMerge [
  # Home-manager context
  (lib.mkIf isHomeManager {
    programs.git = {
      enable = true;
      userName = gitConfig.user.name;
      userEmail = gitConfig.user.email;
    };
    
    programs.zsh.shellAliases = shellAliases;
  })
  
  # NixOS/nix-darwin context
  (lib.mkIf (!isHomeManager) {
    programs.git.enable = true;
    programs.git.config = gitConfig;
    
    programs.zsh.shellAliases = shellAliases;
  })
]
```

### 3. Handle Platform-Specific Settings
Some settings only apply to certain platforms:

```nix
# Apply only on macOS
(lib.mkIf isDarwin {
  # Darwin-specific settings
})

# Apply only on Linux
(lib.mkIf (!isDarwin) {
  # Linux-specific settings
})
```

## Example: shell-config.nix

The `shell-config.nix` module demonstrates this pattern with a real example:

### What It Does
1. Configures git with shared settings
2. Adds shell aliases (works across shells)
3. Sets environment variables
4. Installs essential CLI tools

### How It Works
1. **Context Detection**: Checks `config ? home` to detect home-manager
2. **Shared Configuration**: Git config, aliases, and env vars are defined once
3. **Conditional Application**: 
   - In home-manager: Uses `programs.git`, `programs.zsh`, etc.
   - In NixOS/nix-darwin: Uses system-level `programs` and `environment`
4. **Platform Handling**: Darwin-specific settings can be applied conditionally

## Usage

### In NixOS
```nix
# configuration.nix or modules
{
  imports = [
    ../dendritic/features.d/shell-config.nix
  ];
}
```

### In home-manager
```nix
# home.nix or modules
{
  imports = [
    ../dendritic/features.d/shell-config.nix
  ];
}
```

### In nix-darwin (via home-manager)
Same as home-manager - the module works because it detects the home-manager context.

## Best Practices

### ✅ Do

1. **Extract Common Configuration**
   - Define shared settings in let-bindings
   - Reuse these across different contexts

2. **Use Runtime Detection**
   - Detect context at evaluation time, not build time
   - This enables true cross-platform support

3. **Document the Pattern**
   - Include comments explaining detection logic
   - Explain why each condition is needed

4. **Keep It Simple**
   - Don't over-complicate for edge cases
   - Focus on the common path first

5. **Test Multiple Contexts**
   - Verify in home-manager
   - Verify in NixOS
   - Verify on Darwin if possible

### ❌ Don't

1. **Rely on specialArgs Alone**
   - `specialArgs` are build-time only
   - They don't work for runtime module selection

2. **Duplicate Configuration**
   - If settings are the same, share them
   - Extract to let-bindings

3. **Use Imperative Checks**
   - Stick to declarative conditionals (`lib.mkIf`)
   - Avoid `if-then-else` when possible

4. **Ignore Platform Differences**
   - Some things genuinely work differently
   - Conditional blocks are appropriate for these

## Advanced Techniques

### Nested Conditionals
```nix
# Apply only in home-manager on Darwin
(lib.mkIf (isHomeManager && isDarwin) {
  # macOS home-manager specific
})
```

### Attribute Merging
```nix
# Merge common and context-specific attributes
programs.git = {
  enable = true;
  userName = "Name";
  config = gitConfig // {
    # context-specific additions
  };
}
```

### List Concatenation
```nix
home.packages = with pkgs; [
  git
  neovim
]
++ lib.optionals isDarwin [
  # Darwin-only packages
];
```

## Troubleshooting

### Module Not Applying in home-manager
Check if `config ? home` detection is working:
```nix
# Add debug output
_debug_context = if (config ? home) then "home-manager" else "system";
```

### Darwin-Specific Settings Not Applied
Verify `isDarwin` detection:
```bash
nix eval --raw --expr "builtins.currentSystem"
```

### Flake Check Failures
Run with more details:
```bash
nix flake check --all-systems --show-trace
```

## See Also

- `dendritic/features.d/shell-config.nix` - Concrete example
- `dendritic/nixos.nix` - NixOS configuration system
- `dendritic/darwin.nix` - nix-darwin configuration system
- `dendritic/home-manager.nix` - home-manager configuration system
