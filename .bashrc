# ~/.bashrc - by Matheus

# Se nao tiver sendo executado interativamente, faz nada
case $- in
    *i*) ;;
      *) return;;
esac

# Variáveis vêm do ~/.profile, aqui só aliases
if [ "$XDG_SESSION_TYPE" = "wayland" ] && [ -n "$WAYLAND_DISPLAY" ]; then
    alias code='code --enable-features=UseOzonePlatform --ozone-platform=wayland --disable-gpu-sandbox'
    alias chrome='google-chrome --enable-features=UseOzonePlatform --ozone-platform=wayland'
    alias chromium='chromium --enable-features=UseOzonePlatform --ozone-platform=wayland'
fi

# HISTÓRICO OTIMIZADO
HISTCONTROL=ignoreboth:ignoredups
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s checkwinsize
shopt -s globstar

# PROMPT COM GIT BRANCH
case "$TERM" in
    xterm-color|*-256color|screen-256color|tmux-256color|kitty*) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    if command -v git >/dev/null 2>&1; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(git branch 2>/dev/null | grep "^*" | colrm 1 2 | sed "s/.*/(&)/")\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

# Terminal title
case "$TERM" in
xterm*|rxvt*|kitty*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac

# CORES
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Navegação
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Configuração do nnn
export NNN_PLUG='x:aunpack $nnn'

# Sistema
alias df='df -h'
alias free='free -h'
alias ports='ss -tuln'
alias psg='ps aux | grep -v grep | grep -i'
alias h='history | tail -20'
alias serve='python3 -m http.server 8000'
alias weather='curl wttr.in'

# Desenvolvimento
alias jsonpp='python3 -m json.tool'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'

# Kitty específico
if [ "$TERM" = "xterm-kitty" ]; then
    alias icat='kitty +kitten icat'
    alias kdiff='kitty +kitten diff'
    alias clipboard='kitty +kitten clipboard'
fi

# Criar diretório e entrar
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Backup com timestamp
backup() {
    cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
    echo "Backup criado: $1.bak.$(date +%Y%m%d_%H%M%S)"
}

# Extrair arquivo
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Encontrar processos
psgrep() {
    ps aux | head -1
    ps aux | grep -i "$1" | grep -v grep
}

# COMPLETIONS
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Git completion específico
if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi

# Layout brasileiro APENAS no TTY real
if [ "$TERM" = "linux" ]; then
    sudo loadkeys br-abnt2 2>/dev/null || true
fi

# Função para mover aplicação atual para workspace específico
sway_move_to() {
    case "$1" in
        code|1) swaymsg move container to workspace "1:" ;;
        term|2) swaymsg move container to workspace "2:" ;;
        web|3) swaymsg move container to workspace "3:" ;;
        db|4) swaymsg move container to workspace "4:" ;;
        docs|5) swaymsg move container to workspace "5:" ;;
        git|6) swaymsg move container to workspace "6:" ;;
        *) echo "Uso: sway_move_to [1|2|3|4|5|6]" ;;
    esac
}
alias swmv='sway_move_to'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Carrega o nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Carrega o nvm bash_completion

# Exec o fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
