# Se existir o Bash_version, o .bashrc vai ser incluido no diretorio HOME se nao tiver
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# Aplicações padrão
export EDITOR=/usr/bin/code
export BROWSER=google-chrome
export TERMINAL=kitty
export PAGER=less

# Wayland - APENAS se em sessão Wayland e se não estiver definido
if [ "$XDG_SESSION_TYPE" = "wayland" ] && [ -z "$QT_QPA_PLATFORM" ]; then
    export XDG_CURRENT_DESKTOP=sway
    export QT_QPA_PLATFORM=wayland
    export GDK_BACKEND=wayland
    export MOZ_ENABLE_WAYLAND=1
    export ELECTRON_ENABLE_WAYLAND=1
fi

# GCC colors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Se Display wayland_display e xgd_vtnr existirem, exec o sway
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec sway
fi
