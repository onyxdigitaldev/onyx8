# ============================================================================
#   ___  _   ___   ____  __    ___
#  / _ \| \ | \ \ / /\ \/ /   ( _ )
# | | | |  \| |\ V /  \  /    / _ \
# | |_| | |\  | | |   /  \   | (_) |
#  \___/|_| \_| |_|  /_/\_\   \___/
#
# Desktop Environment - Hyprland + Caelestia Shell
# ============================================================================
#
# USAGE: Import this file in your configuration.nix
#   imports = [ ./desktop.nix ];
#
# For Caelestia theming, use home-manager with caelestia-nixos flake
# ============================================================================

{ config, pkgs, lib, ... }:

{
  # ===========================================================================
  # HYPRLAND
  # ===========================================================================

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  # X11 app compatibility
  };

  # ===========================================================================
  # DISPLAY MANAGER
  # ===========================================================================

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # ===========================================================================
  # XDG PORTALS (for screen sharing, file dialogs, etc.)
  # ===========================================================================

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # ===========================================================================
  # AUDIO
  # ===========================================================================

  # PipeWire for audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ===========================================================================
  # DESKTOP PACKAGES
  # ===========================================================================

  environment.systemPackages = with pkgs; [
    # --- Hyprland Ecosystem ---
    hyprland
    hyprpaper                 # Wallpaper
    hyprpicker                # Color picker
    hyprlock                  # Lock screen
    hypridle                  # Idle daemon
    hyprshot                  # Screenshot

    # --- Quickshell (for Caelestia) ---
    # quickshell              # Uncomment when available in nixpkgs
    # Or use the flake: github:quickshell/quickshell

    # --- Wayland Utilities ---
    wl-clipboard              # Clipboard
    cliphist                  # Clipboard history
    wtype                     # Keyboard automation
    wlr-randr                 # Display config
    kanshi                    # Auto display config

    # --- Launchers ---
    rofi-wayland              # App launcher
    fuzzel                    # Lightweight launcher
    wofi                      # Wayland launcher

    # --- Notifications ---
    dunst                     # Notification daemon
    libnotify                 # notify-send

    # --- Terminal ---
    alacritty                 # GPU terminal
    foot                      # Fast Wayland terminal
    kitty                     # Feature-rich terminal

    # --- File Manager ---
    thunar                    # GTK file manager
    xfce.thunar-volman        # Volume management
    xfce.thunar-archive-plugin
    gnome.nautilus            # GNOME file manager

    # --- Media ---
    mpv                       # Video player
    imv                       # Image viewer
    pavucontrol               # Audio control
    playerctl                 # Media keys

    # --- Theming ---
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6ct
    adwaita-qt
    adwaita-qt6
    papirus-icon-theme
    catppuccin-cursors        # Cursor theme (we'll customize)

    # --- Screenshots ---
    grim                      # Screenshot
    slurp                     # Region select
    swappy                    # Annotation

    # --- System ---
    polkit_gnome              # Auth dialogs
    gnome.gnome-keyring       # Secrets
    networkmanagerapplet      # Network tray
    blueman                   # Bluetooth

    # --- Fonts ---
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
    inter
    roboto
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    material-symbols

    # --- Caelestia Dependencies ---
    cava                      # Audio visualizer
    brightnessctl             # Brightness control
    ddcutil                   # Monitor control
    lm_sensors                # Hardware sensors
    libqalculate              # Calculator
    fish                      # Shell (Caelestia default)
  ];

  # ===========================================================================
  # FONTS
  # ===========================================================================

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # ===========================================================================
  # SERVICES
  # ===========================================================================

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Thunar extras
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true;  # Trash, mounting, etc.
  services.tumbler.enable = true;  # Thumbnails

  # GNOME Keyring
  services.gnome.gnome-keyring.enable = true;

  # ===========================================================================
  # ENVIRONMENT
  # ===========================================================================

  environment.sessionVariables = {
    # Wayland
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";

    # Theming
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # ===========================================================================
  # SECURITY
  # ===========================================================================

  # Polkit for GUI authentication
  security.polkit.enable = true;

  # Allow swaylock to unlock
  security.pam.services.hyprlock = {};
}
