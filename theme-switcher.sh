#!/bin/bash

# Theme switcher for tmux - switches between Catppuccin and Gruvbox themes
# Usage: ./theme-switcher.sh [catppuccin|gruvbox|toggle]

TMUX_CONFIG_DIR="$HOME/.config/tmux"
TMUX_CONF="$TMUX_CONFIG_DIR/tmux.conf"
THEME_FILE="$TMUX_CONFIG_DIR/current-theme"

# Function to get current theme
get_current_theme() {
    if [[ -f "$THEME_FILE" ]]; then
        cat "$THEME_FILE"
    else
        echo "catppuccin"  # default theme
    fi
}

# Function to set theme
set_theme() {
    local theme="$1"
    echo "$theme" > "$THEME_FILE"
}

# Function to apply Catppuccin theme
apply_catppuccin() {
    # Clear existing theme settings
    tmux set-option -g status-style "default" 2>/dev/null || true
    tmux set-option -g window-status-style "default" 2>/dev/null || true
    tmux set-option -g window-status-current-style "default" 2>/dev/null || true
    tmux set-option -g pane-active-border-style "default" 2>/dev/null || true
    tmux set-option -g pane-border-style "default" 2>/dev/null || true
    tmux set-option -g message-style "default" 2>/dev/null || true
    tmux set-option -g message-command-style "default" 2>/dev/null || true
    
    # Set Catppuccin theme
    tmux set-option -g @catppuccin_flavor "frappe"
    tmux set-option -g @catppuccin_window_status_style "slanted"
    
    # Customize date_time format
    tmux set-option -g @catppuccin_date_time_text " %a %d/%m/%Y | %H:%M"
    
   /%m/%Y |e Catppuccin theme
    tmux source-file "$TMUX_CONFIG_DIR/plugins/catppuccin/tmux/catppuccin_tmux.conf"
    
    # Set status line modules
    tmux set-option -g status-right-length 100
    tmux set-option -g status-left-length 100
    tmux set-option -g status-left "(づ๑•ᴗ•๑)づ♡ryenyn "
    tmux set-option -g status-right "#{E:@catppuccin_status_date_time}"
    tmux set-option -ag status-right ""#{E:@catppuccin_status_user}""
    tmux set-option -ag status-right "#{E:@catppuccin_status_uptime}"
}

# Function to apply Gruvbox theme
apply_gruvbox() {
    # Clear existing theme settings
    tmux set-option -g status-style "default" 2>/dev/null || true
    tmux set-option -g window-status-style "default" 2>/dev/null || true
    tmux set-option -g window-status-current-style "default" 2>/dev/null || true
    tmux set-option -g pane-active-border-style "default" 2>/dev/null || true
    tmux set-option -g pane-border-style "default" 2>/dev/null || true
    tmux set-option -g message-style "default" 2>/dev/null || true
    tmux set-option -g message-command-style "default" 2>/dev/null || true
    
    # Set Gruvbox theme options
    tmux set-option -g @tmux-gruvbox "dark256"
    tmux set-option -g @tmux-gruvbox-statusbar-alpha "false"
    tmux set-option -g @tmux-gruvbox-left-status-a "(づ๑•ᴗ•๑)づ♡ryenyn"
    tmux set-option -g @tmux-gruvbox-right-status-x "%a %d/%m/%Y"
    tmux set-option -g @tmux-gruvbox-right-status-y "%H:%M"
    tmux set-option -g @tmux-gruvbox-right-status-z "#h "
    
    # Execute Gruvbox theme script
    bash "$TMUX_CONFIG_DIR/plugins/tmux-gruvbox/gruvbox-tpm.tmux"
}

# Function to toggle between themes
toggle_theme() {
    local current_theme=$(get_current_theme)
    if [[ "$current_theme" == "catppuccin" ]]; then
        apply_gruvbox
        set_theme "gruvbox"
        tmux display-message "Switched to Gruvbox theme"
    else
        apply_catppuccin
        set_theme "catppuccin"
        tmux display-message "Switched to Catppuccin theme"
    fi
}

# Main logic
case "${1:-toggle}" in
    "catppuccin")
        apply_catppuccin
        set_theme "catppuccin"
        tmux display-message "Applied Catppuccin theme"
        ;;
    "gruvbox")
        apply_gruvbox
        set_theme "gruvbox"
        tmux display-message "Applied Gruvbox theme"
        ;;
    "toggle")
        toggle_theme
        ;;
    *)
        echo "Usage: $0 [catppuccin|gruvbox|toggle]"
        exit 1
        ;;
esac
