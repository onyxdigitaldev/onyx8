# Onyx 8

**The Spider** - Red Team Arsenal for NixOS

```
  ___  _   ___   ____  __    ___
 / _ \| \ | \ \ / /\ \/ /   ( _ )
| | | |  \| |\ V /  \  /    / _ \
| |_| | |\  | | |   /  \   | (_) |
 \___/|_| \_| |_|  /_/\_\   \___/
```

## Overview

Onyx 8 is a comprehensive penetration testing and red team environment built on NixOS. Named after the Phantom Troupe's spider (8 legs = 8 domains of expertise), it provides a complete offensive security toolkit with a cohesive desktop environment.

## Components

### `8.nix` - The Arsenal
150+ security tools organized by domain:

| Leg | Domain | Key Tools |
|-----|--------|-----------|
| 1 | Recon & OSINT | nmap, amass, subfinder, sherlock, ffuf |
| 2 | Network Attacks | wireshark, bettercap, responder, crackmapexec |
| 3 | Wireless & RF | aircrack-ng, wifite2, gnuradio, hackrf |
| 4 | Web Application | burpsuite, sqlmap, nuclei, nikto |
| 5 | Exploitation | metasploit, gef, pwntools, exploitdb |
| 6 | Post-Ex & C2 | havoc, mimikatz, evil-winrm, bloodhound |
| 7 | Forensics & IR | volatility3, autopsy, sleuthkit, yara |
| 8 | Reverse Engineering | ghidra, radare2, cutter, gdb |
| + | Hardware | flashrom, openocd, sigrok |
| + | Passwords | hashcat, john, thc-hydra, seclists |

### `desktop.nix` - Hyprland + Caelestia
- Hyprland compositor (Wayland, X11 compat via XWayland)
- Caelestia shell integration
- PipeWire audio
- All desktop dependencies

### `flake.nix` - Nix Flake
Provides NixOS and Home Manager modules for easy integration.

### `hyprland.conf` - Window Manager Config
- 8 workspaces (spider legs)
- Vim keybindings (hjkl)
- Onyx 8 color scheme (dark + red/purple accents)
- Pentest tool workspace assignments

### `caelestia/shell.json` - Shell Theme
Onyx 8 color palette for Caelestia shell.

## Installation

### As a Flake Input

```nix
{
  inputs.onyx8.url = "github:onyxdigitaldev/onyx8";

  outputs = { self, nixpkgs, onyx8, ... }: {
    nixosConfigurations.ghost = nixpkgs.lib.nixosSystem {
      modules = [
        onyx8.nixosModules.default  # Full suite (tools + desktop)
        # OR
        onyx8.nixosModules.onyx8    # Just tools
        onyx8.nixosModules.desktop  # Just desktop
      ];
    };
  };
}
```

### Direct Import

```nix
# configuration.nix
{ config, pkgs, ... }:
{
  imports = [
    /path/to/onyx8/8.nix
    /path/to/onyx8/desktop.nix
  ];
}
```

### Home Manager (user config)

```nix
{
  imports = [ onyx8.homeManagerModules.onyx8 ];
}
```

## Hardware Target

Primary target: **ThinkPad X220** (Ghost)
- Intel Core i5-2520M (Sandy Bridge)
- 16GB RAM
- Coreboot compatible (external flash required)
- Intel ME neutralization planned

## Color Scheme

Onyx 8 uses a dark theme with Phantom Troupe-inspired accents:

| Element | Color |
|---------|-------|
| Background | `#0a0a0a` |
| Background Alt | `#121212` |
| Foreground | `#c9c9c9` |
| Red (primary accent) | `#8b0000` |
| Red Bright | `#cc0000` |
| Purple (secondary) | `#4a0080` |
| Border Focus | `#8b0000` |

## Coreboot Notes

X220 requires external flashing:
- CH341A programmer + SOIC-8 clip
- me_cleaner for Intel ME neutralization
- Full instructions TBD after hardware liberation

## Structure

```
onyx8/
├── 8.nix                 # Pentest tools module
├── desktop.nix           # Hyprland + desktop environment
├── flake.nix             # Nix flake configuration
├── hyprland.conf         # Hyprland WM config
├── caelestia/
│   └── shell.json        # Caelestia theme config
└── README.md
```

## Post-Install Checklist

1. Fresh NixOS minimal install
2. Clone this repo
3. Import modules in configuration.nix
4. `sudo nixos-rebuild switch`
5. Configure user dotfiles via Home Manager
6. (Future) Flash coreboot + neutralize ME

## Terminal

Due to HD 3000 GPU limitations (OpenGL 3.1), use **foot** terminal instead of Ghostty/Alacritty/Kitty.

---

*"The Phantom Troupe's strength lies in its members."*
