#!/usr/bin/env bash

# cyber CLI - Management interface for cybershell framework
# Author: Manus AI

# --- CONFIGURAÇÕES ---
CYBERSHELL_DIR="$HOME/.config/cybershell"
STATE_DIR="$CYBERSHELL_DIR/state"
THEME_FILE="$STATE_DIR/active_theme.txt"
WALLPAPER_FILE="$STATE_DIR/active_wallpaper.txt"

# --- CORES ---
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- FUNÇÕES AUXILIARES ---
log() { echo -e "${CYAN}[cyber]${NC} $1"; }
error() { echo -e "${RED}[error]${NC} $1"; exit 1; }

# --- SUBCOMANDOS ---

show_help() {
    echo -e "${MAGENTA}cybershell CLI v1.0${NC}"
    echo -e "Uso: cyber [comando] [opções]"
    echo ""
    echo -e "Comandos:"
    echo -e "  theme [nome]   Listar ou trocar o tema do oh-my-posh"
    echo -e "  wall [caminho] Listar ou trocar o wallpaper (requer swww)"
    echo -e "  info           Exibir informações do sistema e do framework"
    echo -e "  backup         Fazer backup das configurações para o Git"
    echo -e "  reload         Recarregar o shell atual"
    echo -e "  help           Exibir esta ajuda"
}

manage_theme() {
    if [ -z "$1" ]; then
        log "Temas disponíveis em $CYBERSHELL_DIR/themes/:"
        ls "$CYBERSHELL_DIR/themes/" | sed 's/\.omp\.json//'
        log "Uso: cyber theme [nome]"
    else
        THEME_NAME="$1"
        echo "$THEME_NAME" > "$THEME_FILE"
        log "Tema '$THEME_NAME' selecionado. Execute 'cyber reload' para aplicar."
    fi
}

manage_wallpaper() {
    if [ -z "$1" ]; then
        log "Wallpapers disponíveis em $CYBERSHELL_DIR/wallpapers/:"
        ls "$CYBERSHELL_DIR/wallpapers/"
        log "Uso: cyber wall [nome_ou_caminho]"
    else
        WALL_PATH="$1"
        # Verifica se é um arquivo local ou no diretório de wallpapers
        if [ ! -f "$WALL_PATH" ]; then
            if [ -f "$CYBERSHELL_DIR/wallpapers/$WALL_PATH" ]; then
                WALL_PATH="$CYBERSHELL_DIR/wallpapers/$WALL_PATH"
            else
                error "Wallpaper '$WALL_PATH' não encontrado."
            fi
        fi
        
        # Tenta aplicar com swww se estiver disponível
        if command -v swww &> /dev/null; then
            swww img "$WALL_PATH" --transition-type grow --transition-pos 0.5,0.5
            echo "$WALL_PATH" > "$WALLPAPER_FILE"
            log "Wallpaper aplicado: $(basename "$WALL_PATH")"
        else
            log "swww não encontrado. Wallpaper salvo mas não aplicado."
            echo "$WALL_PATH" > "$WALLPAPER_FILE"
        fi
    fi
}

show_info() {
    echo -e "${MAGENTA}--- CYBERSHELL SYSTEM INFO ---${NC}"
    echo -e "${CYAN}OS:${NC} $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo -e "${CYAN}Kernel:${NC} $(uname -r)"
    echo -e "${CYAN}Shell:${NC} $SHELL"
    echo -e "${CYAN}Terminal:${NC} $TERM"
    echo -e "${CYAN}Tema Ativo:${NC} $(cat "$THEME_FILE" 2>/dev/null || echo "Nenhum")"
    echo -e "${CYAN}Wallpaper:${NC} $(cat "$WALLPAPER_FILE" 2>/dev/null || echo "Nenhum")"
    echo -e "${CYAN}Framework Dir:${NC} $CYBERSHELL_DIR"
}

perform_backup() {
    log "Iniciando backup para o repositório de dotfiles..."
    DOTFILES_REPO="$HOME/dotfiles" # Pode ser tornado configurável
    
    if [ ! -d "$DOTFILES_REPO" ]; then
        error "Repositório $DOTFILES_REPO não encontrado. Configure o caminho do seu repositório de dotfiles."
    fi
    
    # Copiar configurações para o repositório
    cp -rv "$HOME/.config/sway" "$DOTFILES_REPO/"
    cp -rv "$HOME/.config/waybar" "$DOTFILES_REPO/"
    cp -rv "$HOME/.config/kitty" "$DOTFILES_REPO/"
    cp -rv "$HOME/.config/cava" "$DOTFILES_REPO/"
    cp -rv "$CYBERSHELL_DIR" "$DOTFILES_REPO/"
    
    cd "$DOTFILES_REPO"
    git add .
    git commit -m "cybershell backup: $(date +'%Y-%m-%d %H:%M:%S')"
    git push
    log "Backup concluído com sucesso!"
}

reload_shell() {
    log "Recarregando configurações..."
    # Recarrega o shell
    case "$SHELL" in
        */bash) exec bash ;;
        */zsh) exec zsh ;;
        */fish) exec fish ;;
    esac
    
    # Recarrega o Sway se estiver rodando
    if [ -n "$SWAYSOCK" ]; then
        log "Recarregando Sway..."
        swaymsg reload
    fi
}

# --- MAIN ---

case "$1" in
    theme) manage_theme "$2" ;;
    wall) manage_wallpaper "$2" ;;
    info) show_info ;;
    backup) perform_backup ;;
    reload) reload_shell ;;
    help|*) show_help ;;
esac
