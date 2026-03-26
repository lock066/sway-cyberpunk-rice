#!/usr/bin/env bash

# CyberShell Dev Profile
# Author: fr4n & Manus AI

install_dev_tools() {
    log "Instalando ferramentas de desenvolvimento para $DISTRO..."
    
    case $DISTRO in
        arch|endeavouros|manjaro)
            # Tenta instalar pacotes, mas ignora nodejs se houver conflito (já que pnpm/outros podem depender de versões específicas)
            log "Instalando ferramentas de desenvolvimento (Arch)..."
            run_cmd sudo pacman -S --needed --noconfirm docker docker-compose pnpm python python-pip go neovim
            if ! command -v node &> /dev/null; then
                run_cmd sudo pacman -S --needed --noconfirm nodejs || warn "Falha ao instalar nodejs. Verifique conflitos manualmente."
            fi
            ;;
        debian|ubuntu|kali)
            run_cmd sudo apt update
            run_cmd sudo apt install -y docker.io docker-compose nodejs npm python3 python3-pip golang-go neovim
            ;;
        fedora)
            run_cmd sudo dnf install -y docker docker-compose nodejs python3 python3-pip golang neovim
            ;;
        *)
            warn "Distribuição $DISTRO não suportada automaticamente para o perfil dev."
            ;;
    esac

    # Start and enable docker
    if command -v docker &> /dev/null; then
        run_cmd sudo systemctl enable --now docker
        run_cmd sudo usermod -aG docker $USER
    fi
}
