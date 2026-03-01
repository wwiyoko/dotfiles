. "$HOME/.bashrc"

export XDG_CURRENT_DESKTOP="sway"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export QT_QPA_PLATFORM="wayland"
PATH="$PATH:$HOME/bin"

[ "$(tty)" = "/dev/tty1" ] && exec dbus-run-session sway
