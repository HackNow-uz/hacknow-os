# HackNow OS — Bash Configuration

# Interactive check
case $- in
    *i*) ;;
      *) return;;
esac

# History
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

# Path
export PATH="$HOME/.local/bin:$HOME/go/bin:/opt/hacknow-tools/bin:$PATH"
export TERM=xterm-256color
export EDITOR=vim

# Colors
export LESS='-R --use-color -Dd+r$Du+b$'

# Aliases (same as zsh)
if command -v exa >/dev/null 2>&1; then
    alias ls='exa --icons --group-directories-first'
    alias ll='exa -l --icons --git --group-directories-first'
    alias la='exa -la --icons --git --group-directories-first'
    alias lt='exa --tree --level=2 --icons'
else
    alias ll='ls -la --color=auto'
    alias la='ls -A --color=auto'
fi

command -v batcat >/dev/null 2>&1 && alias cat='batcat --style=plain'
alias grep='grep --color=auto'
alias ip='ip -c'
alias ports='ss -tulnp'
alias myip='curl -s ifconfig.me'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias scan='nmap -sC -sV'
alias quickscan='nmap -T4 -F'
alias serve='python3 -m http.server 8080'

# Functions
setip() { export TARGET="$1"; export IP="$1"; echo "[*] Target: $TARGET"; }
mkcd() { mkdir -p "$1" && cd "$1"; }

# Starship
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
else
    # Fallback HackNow prompt
    PS1='\[\033[1;31m\]┌─[\[\033[1;37m\]\u@\h\[\033[1;31m\]]─[\[\033[1;36m\]\w\[\033[1;31m\]]\n└─\[\033[1;31m\]╼ \[\033[0m\]\$ '
fi

# FZF
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && \
    source /usr/share/doc/fzf/examples/key-bindings.bash

# Greeting
if [ -z "$HACKNOW_GREETED" ] && [ -t 1 ]; then
    export HACKNOW_GREETED=1
    command -v neofetch >/dev/null 2>&1 && neofetch 2>/dev/null
fi

# === thefuck ===
if command -v thefuck >/dev/null 2>&1; then
    eval "$(thefuck --alias)"
    alias fk='fuck'
fi
