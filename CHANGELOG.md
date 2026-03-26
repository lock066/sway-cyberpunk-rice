# Changelog

Todas as mudanças notáveis no **CyberShell Framework** serão documentadas neste arquivo.

## [1.0.0] - 2026-03-19

### Adicionado
- **Arquitetura Modular:** Reestruturação completa do projeto em `core`, `modules`, `profiles` e `themes`.
- **Perfis de Instalação:** Suporte para os perfis `minimal`, `dev` e `redteam`.
- **Instalação Universal:** Detecção automática de distribuição Linux (Arch, Debian/Ubuntu, Fedora).
- **Opção --dry-run:** Simulação de instalação segura sem alteração de arquivos.
- **CLI 'cyber':** Interface de linha de comando para gerenciamento global do framework.
- **Identidade Visual:** Novo tema Tokyo Night com interface flutuante na Waybar e Kitty.
- **Documentação Open Source:** Adição de `README.md`, `CONTRIBUTING.md`, `CHANGELOG.md` e `LICENSE`.

### Corrigido
- **Permissões de Execução:** Scripts agora recebem permissões automáticas de execução no instalador.
- **PowerShell AUR:** Correção para instalação do PowerShell via AUR no Arch Linux.
- **Portabilidade de Shell:** Carregadores de shell aprimorados com fallbacks seguros para bash, fish e pwsh.

### Alterado
- **Estrutura de Dotfiles:** Migração de dotfiles simples para módulos injetáveis no sistema.

---
CyberShell Framework v1.0.0 (Professional Open Source Edition)
