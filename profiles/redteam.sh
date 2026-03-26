#!/usr/bin/env bash

# CyberShell RedTeam Profile
# Author: fr4n & Manus AI

# Load dev tools first
PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$PROFILE_DIR/dev.sh" ]; then
    source "$PROFILE_DIR/dev.sh"
fi

install_security_tools() {
    log "Instalando ferramentas de segurança (RedTeam) para $DISTRO..."
    
    case $DISTRO in
        arch|endeavouros|manjaro)
            # Oficiais
            run_cmd sudo pacman -S --needed --noconfirm nmap wireshark-qt sqlmap gobuster nikto hashcat exploitdb aircrack-ng netcat
            
            # Metasploit e Burp via AUR se necessário (alguns distros arch-based já tem no repo oficial)
            if ! command -v msfconsole &> /dev/null; then
                log "Metasploit não encontrado. Tentando instalar..."
                run_cmd sudo pacman -S --needed --noconfirm metasploit || {
                    log "Tentando via AUR..."
                    if command -v yay &> /dev/null; then yay -S --noconfirm metasploit; fi
                }
            fi
            
            if ! command -v burpsuite &> /dev/null; then
                run_cmd sudo pacman -S --needed --noconfirm burpsuite || {
                    if command -v yay &> /dev/null; then yay -S --noconfirm burpsuite; fi
                }
            fi
            ;;
        debian|ubuntu|kali)
            run_cmd sudo apt update
            run_cmd sudo apt install -y nmap metasploit-framework wireshark burpsuite sqlmap gobuster nikto hashcat exploitdb aircrack-ng netcat-traditional
            ;;
        fedora)
            run_cmd sudo dnf install -y nmap metasploit-framework wireshark burpsuite sqlmap gobuster nikto hashcat exploitdb aircrack-ng nc
            ;;
        *)
            warn "Distribuição $DISTRO não suportada automaticamente para o perfil redteam."
            ;;
    esac

    # Add user to wireshark group
    if grep -q "wireshark" /etc/group; then
        run_cmd sudo usermod -aG wireshark $USER
    fi
}
