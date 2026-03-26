# CyberShell Framework

![CyberShell Banner]<img width="1599" height="900" alt="2026-03-26_16h03m55s" src="https://github.com/user-attachments/assets/ec5cbccc-7773-4245-ba52-20f3c0415d0a" />


O **CyberShell Framework** é um ecossistema modular para Linux, projetado para transformar distribuições base em ambientes de trabalho profissionais, estéticos e altamente produtivos. Diferente de um repositório de dotfiles comum, o CyberShell é um **framework de setup** que oferece instalação automatizada, perfis configuráveis e portabilidade entre as principais distribuições Linux.

## 🚀 Principais Funcionalidades

- **Instalação Inteligente:** Detecção automática de distribuição (Arch, Debian/Ubuntu, Fedora).
- **Arquitetura Modular:** Componentes separados em `core`, `modules`, `profiles` e `themes`.
- **Perfis de Instalação:**
  - `minimal`: Apenas o Window Manager (Sway), tema e shell base.
  - `dev`: Minimal + Docker, Node.js, Python, Go e Neovim.
  - `redteam`: Dev + Ferramentas de segurança (Nmap, Metasploit, Wireshark, etc.).
- **Portabilidade Multi-Shell:** Suporte nativo e carregamento automático para `bash`, `fish` e `PowerShell`.
- **CLI de Gerenciamento:** Comando `cyber` para trocar temas, wallpapers e gerenciar o sistema.
- **Fail-Safe & Dry-Run:** Sistema de logs detalhados e opção de simulação de instalação.

## 📂 Estrutura do Projeto

```text
cybershell/
├── core/           # Lógica central e carregadores de shell
├── modules/        # Componentes instaláveis (desktop, shell, tools)
├── profiles/       # Definições de perfis (minimal, dev, redteam)
├── themes/         # Temas oh-my-posh e configurações visuais
├── scripts/        # CLI 'cyber' e utilitários
└── install.sh      # Instalador universal
```

## 🛠️ Instalação

Para instalar o CyberShell, clone o repositório e execute o instalador:

```bash
git clone https://github.com/fr4n/cybershell.git
cd cybershell
chmod +x install.sh
./install.sh --profile dev
```

### Opções do Instalador:
- `--profile [minimal|dev|redteam]`: Define o perfil de ferramentas.
- `--dry-run`: Simula a instalação sem alterar arquivos do sistema.
- `--help`: Exibe todas as opções disponíveis.

## 🎨 Visual Identity

O CyberShell utiliza por padrão o tema **Tokyo Night**, com foco em transparência, cores vibrantes e uma interface flutuante moderna baseada no Sway e Waybar.

## 🗺️ Roadmap

- [ ] Suporte para openSUSE e Gentoo.
- [ ] Módulo para Hyprland.
- [ ] Dashboard de monitoramento via CLI.
- [ ] Integração nativa com Neovim (CyberVim).

## 🤝 Contribuição

Contribuições são muito bem-vindas! Veja o arquivo [CONTRIBUTING.md](CONTRIBUTING.md) para diretrizes.

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

---
Desenvolvido com 💜 por **fr4n** e **Manus AI**.
