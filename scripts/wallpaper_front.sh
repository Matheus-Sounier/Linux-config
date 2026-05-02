#!/bin/bash

# Inicia o daemon
if ! pgrep -x awww-daemon >/dev/null 2>&1; then
    awww-daemon &
fi

# Aguarda o daemon estar pronto
TIMEOUT=50  # 5 segundos
COUNT=0
while ! awww query >/dev/null 2>&1; do
    sleep 0.1
    COUNT=$((COUNT + 1))
    if [ $COUNT -ge $TIMEOUT ]; then
        echo "awww-daemon não respondeu a tempo" >&2
        exit 1
    fi
done

DIR="$HOME/dotfiles/wallpaper_anime/"
CACHE="$HOME/.cache/wallpapers_list"

set_wallpaper() {
    # Recria embaralhada
    if [ ! -f "$CACHE" ] || [ ! -s "$CACHE" ]; then
        find "$DIR" -type f | shuf > "$CACHE"
    fi

    IMG=$(head -n 1 "$CACHE")
    tail -n +2 "$CACHE" > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"

    # wallpaper
    awww img "$IMG" \
        --transition-type "grow" \
        --transition-duration 2 \
        --transition-pos 0.925,0.977 \
        --transition-bezier .43,1.19,1,.4 \
        --transition-fps 60
}

# Troca a cada 1 hora
while true; do
    set_wallpaper
    sleep 1800
done
