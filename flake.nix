{
  description = "Onyx 8 - The Spider | Red Team Arsenal for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Caelestia for Hyprland
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Caelestia NixOS/Home Manager module (optional - for declarative config)
    # caelestia-nixos = {
    #   url = "github:Xellor-Dev/caelestia-nixos";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, home-manager, caelestia-shell, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    # NixOS modules that can be imported
    nixosModules = {
      # Core pentest tools
      onyx8 = import ./8.nix;

      # Desktop environment (Hyprland + Caelestia deps)
      desktop = import ./desktop.nix;

      # Combined - everything
      default = { config, pkgs, lib, ... }: {
        imports = [
          ./8.nix
          ./desktop.nix
        ];
      };
    };

    # Overlay to add Onyx 8 packages/tools
    overlays.default = final: prev: {
      # Add any custom packages here
      onyx8-wallpapers = final.callPackage ./pkgs/wallpapers.nix {};
    };

    # Home Manager module for user-level config
    homeManagerModules = {
      onyx8 = { config, pkgs, lib, ... }: {
        # Hyprland config
        xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

        # Caelestia shell config
        xdg.configFile."caelestia/shell.json".source = ./caelestia/shell.json;

        # Terminal
        programs.alacritty = {
          enable = true;
          settings = {
            window = {
              padding = { x = 12; y = 12; };
              decorations = "none";
              opacity = 0.95;
            };
            font = {
              normal.family = "JetBrainsMono Nerd Font";
              size = 11.0;
            };
            colors = {
              primary = {
                background = "#0a0a0a";
                foreground = "#c9c9c9";
              };
              cursor = {
                text = "#0a0a0a";
                cursor = "#8b0000";
              };
              normal = {
                black = "#0a0a0a";
                red = "#8b0000";
                green = "#1a472a";
                yellow = "#8b8000";
                blue = "#1a1a2e";
                magenta = "#4a0080";
                cyan = "#0d7377";
                white = "#c9c9c9";
              };
              bright = {
                black = "#444444";
                red = "#cc0000";
                green = "#2a6a3a";
                yellow = "#b0a000";
                blue = "#2a2a4e";
                magenta = "#6a00b0";
                cyan = "#0fa5aa";
                white = "#ffffff";
              };
            };
          };
        };

        # Starship prompt
        programs.starship = {
          enable = true;
          settings = {
            format = "[󱗝](bold red) $directory$git_branch$git_status$cmd_duration$line_break$character";
            character = {
              success_symbol = "[➜](bold red)";
              error_symbol = "[✗](bold red)";
            };
            directory = {
              style = "bold white";
              truncation_length = 3;
            };
            git_branch = {
              symbol = " ";
              style = "bold purple";
            };
          };
        };

        # Shell
        programs.fish = {
          enable = true;
          shellAliases = {
            ls = "eza -la --icons";
            cat = "bat";
            grep = "rg";
            find = "fd";
            serve = "python3 -m http.server";
            listen = "nc -lvnp";
            myip = "curl -s ifconfig.me";
          };
        };
      };
    };

    # Development shell for working on Onyx 8
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        git
        nixpkgs-fmt
        nil  # Nix LSP
      ];
    };
  };
}
