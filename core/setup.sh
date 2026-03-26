#!/usr/bin/env bash

# CyberShell Core Functions
# Author: fr4n & Manus AI

# --- BASE DEPENDENCIES ---
install_base_deps() {
    log "Instalando dependências básicas para $DISTRO..."
    
    case $DISTRO in
        arch|endeavouros|manjaro)
            # Instala pacotes oficiais, lidando com conflitos comuns
            log "Limpando conflitos de pacotes no Arch..."
            # Se houver conflito de nodejs, tentamos resolver removendo o lts se necessário ou apenas ignorando
            sudo pacman -R --noconfirm nodejs-lts-jod 2>/dev/null || true
            
            run_cmd sudo pacman -S --needed --noconfirm sway waybar rofi kitty cava git curl unzip ttf-jetbrains-mono-nerd ttf-font-awesome papirus-icon-theme swww polkit-gnome xdg-desktop-portal-wlr brightnessctl pamixer mako grim slurp
            
            # Tenta instalar powershell do AUR se não existir
            if ! command -v pwsh &> /dev/null; then
                log "PowerShell não encontrado nos repos oficiais. Tentando via AUR (yay/paru)..."
                if command -v yay &> /dev/null; then
                    run_cmd yay -S --noconfirm powershell-bin
                elif command -v paru &> /dev/null; then
                    run_cmd paru -S --noconfirm powershell-bin
                else
                    warn "AUR helper não encontrado. Instale 'powershell-bin' manualmente."
                fi
            fi
            ;;
        debian|ubuntu|kali)
            run_cmd sudo apt update
            run_cmd sudo apt install -y sway waybar rofi kitty cava git curl unzip fonts-font-awesome papirus-icon-theme
            # PowerShell no Debian/Ubuntu
            if ! command -v pwsh &> /dev/null; then
                log "Instalando PowerShell Core..."
                run_cmd sudo apt-get install -y wget apt-transport-https software-properties-common
                source /etc/os-release
                run_cmd wget -q https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb
                run_cmd sudo dpkg -i packages-microsoft-prod.deb
                run_cmd rm packages-microsoft-prod.deb
                run_cmd sudo apt-get update
                run_cmd sudo apt-get install -y powershell
            fi
            ;;
        fedora)
            run_cmd sudo dnf install -y sway waybar rofi kitty cava git curl unzip jetbrains-mono-fonts-all fontawesome-fonts papirus-icon-theme swww powershell
            ;;
        *)
            warn "Distribuição $DISTRO não suportada automaticamente. Instale as dependências manualmente."
            ;;
    esac

    # Install oh-my-posh
    if ! command -v oh-my-posh &> /dev/null; then
        log "Instalando oh-my-posh (binário direto)..."
        local arch=$(uname -m)
        local target="posh-linux-amd64"
        [ "$arch" = "aarch64" ] && target="posh-linux-arm64"
        
        if run_cmd sudo curl -sL "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/$target" -o /usr/local/bin/oh-my-posh; then
            run_cmd sudo chmod +x /usr/local/bin/oh-my-posh
            log "oh-my-posh instalado com sucesso."
        else
            warn "Falha ao baixar oh-my-posh. Verifique sua conexão."
        fi
    else
        log "oh-my-posh já está instalado."
    fi
}

# --- DOTFILES ---
apply_dotfiles() {
    log "Aplicando dotfiles do framework..."
    local config_dir="$HOME/.config"
    mkdir -p "$config_dir"
    
    # Copy core dotfiles
    for dir in sway waybar kitty rofi cava; do
        if [ -d "$PROJECT_DIR/modules/desktop/$dir" ]; then
            run_cmd cp -rv "$PROJECT_DIR/modules/desktop/$dir" "$config_dir/"
        fi
    done

    # Setup CyberShell directory
    local cs_dir="$HOME/.config/cybershell"
    mkdir -p "$cs_dir"/{modules,themes,wallpapers,scripts,runtime,state}
    
    # Copy scripts and themes
    if [ -d "$PROJECT_DIR/scripts" ]; then
        run_cmd cp -rv "$PROJECT_DIR/scripts/"* "$cs_dir/scripts/"
    fi
    if [ -d "$PROJECT_DIR/themes" ]; then
        run_cmd cp -rv "$PROJECT_DIR/themes/"* "$cs_dir/themes/"
    fi
    
    # Set permissions
    run_cmd chmod +x "$cs_dir/scripts/cyber.sh"
    run_cmd sudo ln -sf "$cs_dir/scripts/cyber.sh" /usr/local/bin/cyber
}

# --- SHELL LOADERS ---
setup_shell_loaders() {
    log "Configurando carregadores de shell..."
    local cs_dir="$HOME/.config/cybershell"
    
    # Copy loader scripts to config dir
    if [ -f "$PROJECT_DIR/core/init.sh" ]; then run_cmd cp "$PROJECT_DIR/core/init.sh" "$cs_dir/init.sh"; fi
    if [ -f "$PROJECT_DIR/core/init.fish" ]; then run_cmd cp "$PROJECT_DIR/core/init.fish" "$cs_dir/init.fish"; fi
    if [ -f "$PROJECT_DIR/core/init.ps1" ]; then run_cmd cp "$PROJECT_DIR/core/init.ps1" "$cs_dir/init.ps1"; fi

    # Inject into shell configs
    local bashrc="$HOME/.bashrc"
    local zshrc="$HOME/.zshrc"
    local fish_config="$HOME/.config/fish/config.fish"
    local pwsh_profile="$HOME/.config/powershell/Microsoft.PowerShell_profile.ps1"

    # Bash/Zsh
    for rc in "$bashrc" "$zshrc"; do
        [ -f "$rc" ] || run_cmd touch "$rc"
        if ! grep -q "cybershell/init.sh" "$rc"; then
            run_cmd echo -e "\n# CyberShell Loader\n[ -f \"$cs_dir/init.sh\" ] && . \"$cs_dir/init.sh\"" >> "$rc"
        fi
    done

    # Fish
    if command -v fish &> /dev/null; then
        mkdir -p "$(dirname "$fish_config")"
        [ -f "$fish_config" ] || run_cmd touch "$fish_config"
        if ! grep -q "cybershell/init.fish" "$fish_config"; then
            run_cmd echo -e "\n# CyberShell Loader\n[ -f \"$cs_dir/init.fish\" ] && source \"$cs_dir/init.fish\"" >> "$fish_config"
        fi
    fi

    # PowerShell
    if command -v pwsh &> /dev/null; then
        mkdir -p "$(dirname "$pwsh_profile")"
        [ -f "$pwsh_profile" ] || run_cmd touch "$pwsh_profile"
        if ! grep -q "cybershell/init.ps1" "$pwsh_profile"; then
            run_cmd echo -e "\n# CyberShell Loader\nif (Test-Path \"$cs_dir/init.ps1\") { . \"$cs_dir/init.ps1\" }" >> "$pwsh_profile"
        fi
    fi
}
