# HackNow OS — Zsh Configuration

# === History ===
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

# === Path ===
export PATH="$HOME/.local/bin:$HOME/go/bin:/opt/hacknow-tools/bin:$PATH"
export TERM=xterm-256color
export EDITOR=vim
export PAGER=less
export LESS='-R --use-color -Dd+r$Du+b$'

# === Completion ===
autoload -Uz compinit
compinit -i
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{red}%d%f'

# === Key bindings (Emacs-like) ===
bindkey -e
# History qidirish — built-in widget (up-line-or-search ham terminda search beradi)
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
# history-substring-search — Bookworm'da paket yo'q, qo'lda o'rnatilsa faollashadi
if [ -f /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# === Aliases ===
# ls — exa bilan (agar bor bo'lsa)
if command -v exa >/dev/null 2>&1; then
    alias ls='exa --icons --group-directories-first'
    alias ll='exa -l --icons --git --group-directories-first'
    alias la='exa -la --icons --git --group-directories-first'
    alias lt='exa --tree --level=2 --icons'
else
    alias ll='ls -la --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
fi

# cat — bat bilan
command -v batcat >/dev/null 2>&1 && alias cat='batcat --style=plain'
command -v bat >/dev/null 2>&1 && alias cat='bat --style=plain'

# grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Tarmoq
alias ip='ip -c'
alias ports='ss -tulnp'
alias myip='curl -s ifconfig.me'
alias localip="ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1"

# Tizim
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias update='sudo apt update && sudo apt upgrade -y'

# === Pentesting aliases ===
alias serve='python3 -m http.server 8080'
alias webup='python3 -m http.server'
alias linenum='find / -perm -4000 -type f 2>/dev/null'
alias suid='find / -perm -4000 -type f 2>/dev/null'
alias scan='nmap -sC -sV'
alias quickscan='nmap -T4 -F'
alias fullscan='nmap -sC -sV -p-'
alias udpscan='nmap -sU --top-ports 100'
alias hn-tools='ls /opt/hacknow-tools/'

# === Foydali funksiyalar ===
setip() { export TARGET="$1"; export IP="$1"; echo "[*] Target: $TARGET"; }
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "Unsupported: $1" ;;
        esac
    fi
}

# === Plugins (zsh-autosuggestions + syntax-highlighting) ===
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5a6a84'

[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# === FZF integration ===
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
    source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && \
    source /usr/share/doc/fzf/examples/completion.zsh

export FZF_DEFAULT_OPTS="
  --color=bg+:#111827,bg:#0a0a0a,spinner:#FF1744,hl:#FF1744
  --color=fg:#f0f0f0,header:#FF1744,info:#00d4ff,pointer:#FF1744
  --color=marker:#00FF41,fg+:#ffffff,prompt:#FF1744,hl+:#FF6680
  --border=rounded --margin=1 --padding=1
"

# === Starship prompt ===
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
else
    # Fallback HackNow prompt
    autoload -U colors && colors
    PROMPT='%B%F{red}┌─[%F{white}%n@%m%F{red}]─[%F{cyan}%~%F{red}]
└─%F{red}╼ %F{white}%b'
fi

# === Welcome neofetch (birinchi terminal) ===
if [ -z "$HACKNOW_GREETED" ] && [ -t 1 ]; then
    export HACKNOW_GREETED=1
    command -v neofetch >/dev/null 2>&1 && neofetch 2>/dev/null
fi

# === HackNow productivity additions ===

# zoxide — smart cd
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd='z'  # z folder_name bilan o'tish
fi

# tldr — qisqa man
if command -v tldr >/dev/null 2>&1; then
    alias help='tldr'
fi

# bat — ranglar bilan cat
if command -v batcat >/dev/null 2>&1; then
    alias cat='batcat --style=plain --paging=never'
    alias bcat='batcat'
    export BAT_THEME='base16-256'
fi

# fd-find — find o'rniga
if command -v fdfind >/dev/null 2>&1; then
    alias fd='fdfind'
fi

# btop — htop o'rniga
if command -v btop >/dev/null 2>&1; then
    alias top='btop'
fi

# tmux quick start
alias t='tmux new -As hacknow'
alias td='tmux detach'
alias tk='tmux kill-session'
alias tls='tmux ls'

# Quick edit configs
alias ezsh='${EDITOR:-vim} ~/.zshrc'
alias etmux='${EDITOR:-vim} ~/.tmux.conf'
alias envim='${EDITOR:-vim} ~/.config/nvim/init.vim'
alias starshipcfg='${EDITOR:-vim} ~/.config/starship.toml'

# Quick navigation
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias pt='cd ~/Pentest'
alias home='cd ~'

# History
alias h='history'
alias hgrep='history | grep'

# === thefuck — typo tuzatish ===
if command -v thefuck >/dev/null 2>&1; then
    eval "$(thefuck --alias)"
    alias fk='fuck'  # Qulaylik uchun
fi
