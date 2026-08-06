#!/bin/bash

set -euo pipefail

# Define o executável
AWWW="${AWWW:-$HOME/.cargo/bin/awww}"
AWWW_DAEMON="${AWWW_DAEMON:-$HOME/.cargo/bin/awww-daemon}"
AWWW_DAEMON_NAME="$(basename "$AWWW_DAEMON")"
DIR="$HOME/dotfiles/wallpaper_anime"
CACHE="$HOME/.cache/wallpapers_list"
LOG="$HOME/.cache/wallpaper_front.log"
mkdir -p "$HOME/.cache"

log() {
    echo "[$(date '+%F %T')] $*" | tee -a "$LOG" >&2
}

# pasta de wallpapers existe
if [ ! -d "$DIR" ]; then
    log "Erro: Diretório $DIR não existe."
    exit 1
fi

ensure_awww_daemon() {
    if ! command -v "$AWWW_DAEMON" >/dev/null 2>&1; then
        log "Erro: '$AWWW_DAEMON' não foi encontrado no PATH."
        return 1
    fi

    if ! pgrep -x "$AWWW_DAEMON_NAME" >/dev/null 2>&1; then
        log "Iniciando $AWWW_DAEMON..."
        "$AWWW_DAEMON" --quiet >/dev/null 2>&1 &
    fi

    return 0
}

check_awww() {
    if ! command -v "$AWWW" >/dev/null 2>&1; then
        log "Erro: '$AWWW' não foi encontrado no PATH."
        return 1
    fi

    ensure_awww_daemon || return 1

    if [ -z "${WAYLAND_DISPLAY:-}" ]; then
        log "Aviso: WAYLAND_DISPLAY não está definido ainda."
        return 1
    fi

    if [ -z "${XDG_RUNTIME_DIR:-}" ]; then
        log "Aviso: XDG_RUNTIME_DIR não está definido ainda."
        return 1
    fi

    for attempt in $(seq 1 10); do
        if "$AWWW" query >>"$LOG" 2>&1; then
            return 0
        fi

        log "awww ainda não está pronto (tentativa $attempt/10)."
        sleep 5
    done

    log "Erro: não foi possível conectar ao daemon do awww."
    return 1
}

set_wallpaper() {
    # Se o cache não existir ou estiver vazio, recria a lista embaralhada
    if [ ! -f "$CACHE" ] || [ ! -s "$CACHE" ]; then
        find "$DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) | shuf > "$CACHE"
    fi

    # Pega a primeira imagem da fila
    IMG=$(head -n 1 "$CACHE")
    tail -n +2 "$CACHE" > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"

    if [ -z "$IMG" ]; then
        log "Nenhuma imagem encontrada em $DIR."
        return 1
    fi

    if ! check_awww; then
        return 1
    fi

    log "Aplicando wallpaper: $IMG"
    if ! "$AWWW" img "$IMG" \
        --transition-type "grow" \
        --transition-duration 2 \
        --transition-pos 0.925,0.977 \
        --transition-bezier .43,1.19,1,.4 \
        --transition-fps 60 >>"$LOG" 2>&1; then
        log "Falha ao aplicar wallpaper com awww. Veja $LOG para detalhes."
        return 1
    fi
}

# Loop infinito a cada 20 minutos
while true; do
    if set_wallpaper; then
        sleep 1200
    else
        log "Aguardando 30 segundos antes de tentar novamente."
        sleep 30
    fi
done
