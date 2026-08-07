#!/bin/bash
set -euo pipefail

AWWW="${AWWW:-$HOME/.cargo/bin/awww}"
AWWW_DAEMON="${AWWW_DAEMON:-$HOME/.cargo/bin/awww-daemon}"
AWWW_DAEMON_NAME="$(basename "$AWWW_DAEMON")"
DIR="$HOME/dotfiles/wallpaper_anime"
CACHE="$HOME/.cache/wallpapers_list"
LOG="$HOME/.cache/wallpaper_front.log"
LAST_IMG_FILE="$HOME/.cache/wallpaper_last_img"
mkdir -p "$HOME/.cache"

log() {
    echo "[$(date '+%F %T')] $*" | tee -a "$LOG" >&2
}

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

apply_image() {
    local IMG="$1"
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
    echo "$IMG" > "$LAST_IMG_FILE"
}

next_image() {
    if [ ! -f "$CACHE" ] || [ ! -s "$CACHE" ]; then
        find "$DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) | shuf > "$CACHE"
    fi
    local IMG
    IMG=$(head -n 1 "$CACHE")
    tail -n +2 "$CACHE" > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
    echo "$IMG"
}

set_wallpaper() {
    local IMG
    IMG=$(next_image)
    if [ -z "$IMG" ]; then
        log "Nenhuma imagem encontrada em $DIR."
        return 1
    fi
    apply_image "$IMG"
}

watch_monitor_events() {
    local sock="${XDG_RUNTIME_DIR:-}/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-}/.socket2.sock"
    # espera o socket existir (pode demorar um pouco no boot)
    for i in $(seq 1 20); do
        [ -S "$sock" ] && break
        sleep 1
    done
    if [ ! -S "$sock" ]; then
        log "Aviso: socket de eventos do Hyprland não encontrado, watcher desativado."
        return
    fi
    log "Watcher de monitor iniciado, ouvindo $sock"
    # socat lê o stream
    socat -U - UNIX-CONNECT:"$sock" | while read -r line; do
        case "$line" in
            monitoradded*|monitorremoved*)
                log "Evento detectado: $line — reaplicando wallpaper imediatamente."
                sleep 2  # dá um tempo pro output se estabilizar
                if [ -f "$LAST_IMG_FILE" ]; then
                    apply_image "$(cat "$LAST_IMG_FILE")" || true
                else
                    set_wallpaper || true
                fi
                ;;
        esac
    done
}

watch_monitor_events &

# Loop principal de rotação a cada 20 minutos
while true; do
    if set_wallpaper; then
        sleep 1200
    else
        log "Aguardando 30 segundos antes de tentar novamente."
        sleep 30
    fi
done