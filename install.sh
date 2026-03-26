#!/usr/bin/env bash

# CyberShell Framework Installer
# Professional Open Source Edition
# Author: fr4n & Manus AI

set -e

# --- COLORS ---
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- CONFIG ---
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$HOME/.local/share/cybershell/install.log"
DRY_RUN=false
PROFILE="minimal"
DISTRO=""

# --- FUNCTIONS ---
log() { echo -e "${CYAN}[cybershell]${NC} $1" >&2; }
error() { echo -e "${RED}[error]${NC} $1" >&2; exit 1; }
success() { echo -e "${GREEN}[success]${NC} $1" >&2; }
warn() { echo -e "${YELLOW}[warning]${NC} $1" >&2; }

# --- LOGGING SETUP ---
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

# --- DISTRO DETECTION ---
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    elif type lsb_release >/dev/null 2>&1; then
        DISTRO=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    else
        DISTRO=$(uname -s | tr '[:upper:]' '[:lower:]')
    fi
    log "Distribuição detectada: ${MAGENTA}$DISTRO${NC}"
}

# --- HELP ---
show_help() {
    echo -e "${MAGENTA}CyberShell Framework Installer${NC}"
    echo -e "Uso: ./install.sh [opções]"
    echo ""
    echo -e "Opções:"
    echo -e "  --profile [name]  Define o perfil: minimal (default), dev, redteam"
    echo -e "  --dry-run         Simula a instalação sem alterar o sistema"
    echo -e "  --help            Mostra esta ajuda"
    echo ""
    echo -e "Perfis:"
    echo -e "  minimal  -> Window Manager (Sway) + Theme + Shell Base"
    echo -e "  dev      -> Minimal + Docker, Node.js, Python, Go, Neovim"
    echo -e "  redteam  -> Dev + Nmap, Metasploit, Wireshark, BurpSuite"
}

# --- PARSE ARGUMENTS ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --profile) PROFILE="$2"; shift ;;
        --dry-run) DRY_RUN=true ;;
        --help) show_help; exit 0 ;;
        *) error "Opção desconhecida: $1. Use --help para ajuda." ;;
    esac
    shift
done

# --- EXECUTION ---
run_cmd() {
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN]${NC} Executando: $*" >&2
    else
        # Execute the command. If it contains redirecionamento or pipes, use eval.
        # Otherwise, execute directly to be safer with special characters.
        if [[ "$*" == *">"* || "$*" == *"|"* || "$*" == *"<"* ]]; then
            if ! eval "$*"; then
                warn "Falha ao executar: $*. Continuando..."
                return 1
            fi
        else
            if ! "$@"; then
                warn "Falha ao executar: $*. Continuando..."
                return 1
            fi
        fi
    fi
    return 0
}

# Verificação de conectividade
check_internet() {
    log "Verificando conexão com a internet..."
    if ! ping -c 1 google.com &> /dev/null; then
        error "Sem conexão com a internet. Verifique sua rede e tente novamente."
    fi
}

# --- INSTALLER CORE ---
main() {
    check_internet

    echo -e "${MAGENTA}"
    echo "  ____      _                        _          _ _ "
    echo " / ___|   _| |__   ___ _ __ ___  ___| |__   ___| | |"
    echo "| |  | | | | '_ \ / _ \ '__/ __|/ _ \ '_ \ / _ \ | |"
    echo "| |__| |_| | |_) |  __/ |  \__ \  __/ | | |  __/ | |"
    echo " \____\__, |_.__/ \___|_|  |___/\___|_| |_|\___|_|_|"
    echo "      |___/                                         "
    echo -e "${NC}"
    log "Iniciando instalação modular (Perfil: ${YELLOW}$PROFILE${NC})..."

    detect_distro
    
    # Load Core Modules
    if [ -f "$PROJECT_DIR/core/setup.sh" ]; then
        source "$PROJECT_DIR/core/setup.sh"
    fi

    # Load Profile Configuration
    if [ -f "$PROJECT_DIR/profiles/$PROFILE.sh" ]; then
        log "Carregando perfil: $PROFILE"
        source "$PROJECT_DIR/profiles/$PROFILE.sh"
    else
        error "Perfil '$PROFILE' não encontrado em profiles/"
    fi

    # Execute Installation Steps
    install_base_deps
    apply_dotfiles
    setup_shell_loaders
    
    if [[ "$PROFILE" == "dev" || "$PROFILE" == "redteam" ]]; then
        install_dev_tools
    fi
    
    if [[ "$PROFILE" == "redteam" ]]; then
        install_security_tools
    fi

    success "CyberShell Framework instalado com sucesso (Perfil: $PROFILE)!"
    log "Log detalhado em: $LOG_FILE"
}

# --- INITIALIZE ---
main
