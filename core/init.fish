#!/usr/bin/env fish

# cybershell loader for fish
# Author: Manus AI

# --- VARIÁVEIS DE AMBIENTE ---
set -gx CYBERSHELL_DIR "$HOME/.config/cybershell"
set -gx CYBERSHELL_STATE_DIR "$CYBERSHELL_DIR/state"
set -gx CYBERSHELL_THEME_FILE "$CYBERSHELL_STATE_DIR/active_theme.txt"
set -gx CURRENT_SHELL "fish"

# --- CARREGAMENTO DO OH-MY-POSH ---
if command -v oh-my-posh > /dev/null
    # Definir tema padrão se o arquivo de estado não existir
    if not test -f "$CYBERSHELL_THEME_FILE"
        echo "tokyonight_storm" > "$CYBERSHELL_THEME_FILE"
    end
    
    set ACTIVE_THEME (cat "$CYBERSHELL_THEME_FILE")
    
    # Tenta encontrar o tema no diretório do cybershell primeiro, depois no sistema
    if test -f "$CYBERSHELL_DIR/themes/$ACTIVE_THEME.omp.json"
        oh-my-posh init fish --config "$CYBERSHELL_DIR/themes/$ACTIVE_THEME.omp.json" | source
    else
        # Fallback para temas padrão do oh-my-posh
        oh-my-posh init fish --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$ACTIVE_THEME.omp.json" | source
    end
else
    # Prompt minimalista cyberpunk de fallback
    function fish_prompt
        set_color cyan
        echo -n "["
        set_color magenta
        echo -n "cybershell"
        set_color cyan
        echo -n "] "
        set_color white
        echo -n (prompt_pwd)
        set_color green
        echo -n " ❯ "
        set_color normal
    end
end

# --- ALIASES E FUNÇÕES ---
# O comando 'cyber' agora é global via /usr/local/bin/cyber
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# --- CARREGAMENTO DE MÓDULOS ---
for module in "$CYBERSHELL_DIR/modules"/*.fish
    if test -f "$module"
        source "$module"
    end
end
