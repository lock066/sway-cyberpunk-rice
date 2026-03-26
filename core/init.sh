#!/usr/bin/env bash

# cybershell loader for bash/zsh
# Author: Manus AI

# --- VARIÁVEIS DE AMBIENTE ---
export CYBERSHELL_DIR="$HOME/.config/cybershell"
export CYBERSHELL_STATE_DIR="$CYBERSHELL_DIR/state"
export CYBERSHELL_THEME_FILE="$CYBERSHELL_STATE_DIR/active_theme.txt"

# --- DETECÇÃO DE SHELL ---
if [ -n "$ZSH_VERSION" ]; then
    export CURRENT_SHELL="zsh"
elif [ -n "$BASH_VERSION" ]; then
    export CURRENT_SHELL="bash"
fi

# --- CARREGAMENTO DO OH-MY-POSH ---
if command -v oh-my-posh &> /dev/null; then
    # Definir tema padrão se o arquivo de estado não existir
    [ ! -f "$CYBERSHELL_THEME_FILE" ] && echo "tokyonight_storm" > "$CYBERSHELL_THEME_FILE"
    
    ACTIVE_THEME=$(cat "$CYBERSHELL_THEME_FILE")
    
    # Tenta encontrar o tema no diretório do cybershell primeiro, depois no sistema
    if [ -f "$CYBERSHELL_DIR/themes/$ACTIVE_THEME.omp.json" ]; then
        eval "$(oh-my-posh init $CURRENT_SHELL --config "$CYBERSHELL_DIR/themes/$ACTIVE_THEME.omp.json")"
    else
        # Fallback para temas padrão do oh-my-posh
        eval "$(oh-my-posh init $CURRENT_SHELL --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$ACTIVE_THEME.omp.json")"
    fi
else
    # Prompt minimalista cyberpunk de fallback
    if [ "$CURRENT_SHELL" = "zsh" ]; then
        PROMPT='%F{cyan}[%f%F{magenta}cybershell%f%F{cyan}]%f %F{white}%~%f %F{green}❯%f '
    else
        PS1='\[\e[0;36m\][\[\e[0;35m\]cybershell\[\e[0;36m\]] \[\e[0;37m\]\w \[\e[0;32m\]❯ \[\e[0m\]'
    fi
fi

# --- ALIASES E FUNÇÕES ---
# O comando 'cyber' agora é global via /usr/local/bin/cyber
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# --- CARREGAMENTO DE MÓDULOS ---
for module in "$CYBERSHELL_DIR/modules"/*.sh; do
    [ -f "$module" ] && . "$module"
done
