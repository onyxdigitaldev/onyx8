# ============================================================================
#   ___  _   ___   ____  __    ___
#  / _ \| \ | \ \ / /\ \/ /   ( _ )
# | | | |  \| |\ V /  \  /    / _ \
# | |_| | |\  | | |   /  \   | (_) |
#  \___/|_| \_| |_|  /_/\_\   \___/
#
# Qtile Configuration - The Spider
# ============================================================================

import os
import subprocess
from typing import List

from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# ============================================================================
# SETTINGS
# ============================================================================

mod = "mod4"  # Super key
terminal = "alacritty"
browser = "firefox"
file_manager = "thunar"
launcher = "rofi -show drun"
power_menu = "rofi -show power-menu -modi power-menu:rofi-power-menu"

# ============================================================================
# COLORS - Onyx 8 Theme
# ============================================================================

colors = {
    # Base
    "bg": "#0a0a0a",
    "bg_alt": "#121212",
    "bg_highlight": "#1a1a1a",
    "fg": "#c9c9c9",
    "fg_dim": "#666666",
    "fg_bright": "#ffffff",

    # Accent - Spider / Phantom Troupe
    "red": "#8b0000",
    "red_bright": "#cc0000",
    "purple": "#4a0080",
    "purple_dim": "#2d004d",
    "blue": "#1a1a2e",
    "cyan": "#0d7377",
    "green": "#1a472a",
    "yellow": "#8b8000",
    "orange": "#8b4000",

    # UI States
    "border_focus": "#8b0000",
    "border_normal": "#1a1a1a",
    "border_urgent": "#cc0000",

    # Bar
    "bar_bg": "#0a0a0a",
    "bar_fg": "#c9c9c9",
    "widget_bg": "#121212",
}

# ============================================================================
# KEYBINDINGS
# ============================================================================

keys = [
    # Window Navigation
    Key([mod], "h", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move focus to next window"),

    # Window Movement
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Window Resizing
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset window sizes"),

    # Layout Control
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod, "shift"], "space", lazy.window.toggle_floating(), desc="Toggle floating"),

    # Window Actions
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # Applications
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),
    Key([mod], "e", lazy.spawn(file_manager), desc="Launch file manager"),
    Key([mod], "r", lazy.spawn(launcher), desc="Launch rofi"),
    Key([mod], "p", lazy.spawn(power_menu), desc="Power menu"),

    # Screenshots
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Screenshot selection"),
    Key([mod], "Print", lazy.spawn("flameshot full -p ~/Pictures/Screenshots"), desc="Full screenshot"),

    # Volume Control
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),

    # Brightness Control
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),

    # Lock Screen
    Key([mod], "x", lazy.spawn("i3lock -c 0a0a0a"), desc="Lock screen"),
]

# ============================================================================
# GROUPS (WORKSPACES)
# ============================================================================

# Spider legs - 8 workspaces
group_config = [
    ("1", "󰲠", []),                    # Main
    ("2", "󰲢", []),                    # Code
    ("3", "󰲤", [Match(wm_class="firefox")]),  # Web
    ("4", "󰲦", []),                    # Files
    ("5", "󰲨", [Match(wm_class="burpsuite")]),  # Pentest
    ("6", "󰲪", []),                    # Terminal
    ("7", "󰲬", [Match(wm_class="obsidian")]),  # Notes
    ("8", "󰲮", []),                    # Misc
]

groups = []
for name, icon, matches in group_config:
    groups.append(Group(name, label=icon, matches=matches))

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc=f"Move window to group {i.name}"),
    ])

# ============================================================================
# LAYOUTS
# ============================================================================

layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": colors["border_focus"],
    "border_normal": colors["border_normal"],
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Max(**layout_theme),
    layout.Floating(**layout_theme),
    layout.Columns(**layout_theme, border_focus_stack=colors["purple"]),
]

# ============================================================================
# WIDGETS
# ============================================================================

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=13,
    padding=8,
    foreground=colors["fg"],
    background=colors["bar_bg"],
)

extension_defaults = widget_defaults.copy()

def get_widgets():
    return [
        # Left Side
        widget.Spacer(length=8),

        widget.TextBox(
            text="󱗝",  # Spider icon
            fontsize=20,
            foreground=colors["red"],
            mouse_callbacks={"Button1": lazy.spawn(launcher)},
        ),

        widget.Spacer(length=16),

        widget.GroupBox(
            fontsize=16,
            margin_y=4,
            margin_x=4,
            padding_y=6,
            padding_x=6,
            borderwidth=2,
            active=colors["fg"],
            inactive=colors["fg_dim"],
            rounded=False,
            highlight_method="line",
            highlight_color=[colors["bg"], colors["bg_highlight"]],
            this_current_screen_border=colors["red"],
            this_screen_border=colors["purple"],
            urgent_border=colors["border_urgent"],
        ),

        widget.Spacer(length=16),

        widget.WindowName(
            foreground=colors["fg_dim"],
            max_chars=50,
        ),

        # Center spacer
        widget.Spacer(),

        # Right Side - System Info
        widget.Systray(
            padding=8,
        ),

        widget.Spacer(length=16),

        # Network
        widget.TextBox(
            text="󰖩",
            fontsize=16,
            foreground=colors["cyan"],
        ),
        widget.Net(
            interface="wlan0",
            format="{down:.0f}{down_suffix}",
            foreground=colors["fg"],
        ),

        widget.Spacer(length=16),

        # CPU
        widget.TextBox(
            text="󰍛",
            fontsize=16,
            foreground=colors["purple"],
        ),
        widget.CPU(
            format="{load_percent}%",
            foreground=colors["fg"],
        ),

        widget.Spacer(length=16),

        # Memory
        widget.TextBox(
            text="󰘚",
            fontsize=16,
            foreground=colors["green"],
        ),
        widget.Memory(
            format="{MemUsed:.0f}M",
            foreground=colors["fg"],
        ),

        widget.Spacer(length=16),

        # Volume
        widget.TextBox(
            text="󰕾",
            fontsize=16,
            foreground=colors["yellow"],
        ),
        widget.Volume(
            foreground=colors["fg"],
        ),

        widget.Spacer(length=16),

        # Battery (for laptop)
        widget.TextBox(
            text="󰁹",
            fontsize=16,
            foreground=colors["orange"],
        ),
        widget.Battery(
            format="{percent:2.0%}",
            foreground=colors["fg"],
            low_foreground=colors["red_bright"],
            low_percentage=0.2,
        ),

        widget.Spacer(length=16),

        # Clock
        widget.TextBox(
            text="󰥔",
            fontsize=16,
            foreground=colors["red"],
        ),
        widget.Clock(
            format="%H:%M",
            foreground=colors["fg"],
        ),

        widget.Spacer(length=8),

        # Power button
        widget.TextBox(
            text="󰐥",
            fontsize=18,
            foreground=colors["red"],
            mouse_callbacks={"Button1": lazy.spawn(power_menu)},
        ),

        widget.Spacer(length=8),
    ]

# ============================================================================
# SCREENS
# ============================================================================

screens = [
    Screen(
        top=bar.Bar(
            get_widgets(),
            32,
            background=colors["bar_bg"],
            margin=[8, 8, 0, 8],  # top, right, bottom, left
            opacity=0.95,
        ),
    ),
]

# ============================================================================
# MOUSE
# ============================================================================

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# ============================================================================
# FLOATING RULES
# ============================================================================

floating_layout = layout.Floating(
    border_focus=colors["border_focus"],
    border_normal=colors["border_normal"],
    border_width=2,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="Pavucontrol"),
        Match(wm_class="Nm-connection-editor"),
        Match(wm_class="flameshot"),
    ]
)

# ============================================================================
# HOOKS
# ============================================================================

@hook.subscribe.startup_once
def autostart():
    """Run on Qtile startup"""
    home = os.path.expanduser("~")
    autostart_script = os.path.join(home, ".config/qtile/autostart.sh")
    if os.path.exists(autostart_script):
        subprocess.Popen([autostart_script])

@hook.subscribe.client_new
def float_dialogs(window):
    """Float dialog windows"""
    if window.window.get_wm_type() == "dialog" or window.window.get_wm_transient_for():
        window.floating = True

# ============================================================================
# GENERAL SETTINGS
# ============================================================================

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D"  # Java compatibility
