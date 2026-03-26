# Guia de Contribuição para o CyberShell Framework

Obrigado por seu interesse em contribuir com o **CyberShell Framework**! Como um projeto open source, sua colaboração é fundamental para tornar o CyberShell a melhor ferramenta de setup Linux.

## Como Contribuir

### 1. Relatando Bugs
- Verifique se o bug já foi relatado nas **Issues**.
- Se não, abra uma nova issue com uma descrição clara, passos para reproduzir e informações sobre sua distribuição e hardware.

### 2. Sugerindo Melhorias
- Sinta-se à vontade para sugerir novas funcionalidades ou melhorias em módulos existentes.
- Descreva o caso de uso e como a melhoria beneficiaria outros usuários.

### 3. Pull Requests (PRs)
- Faça um **fork** do repositório.
- Crie uma branch para sua funcionalidade ou correção (`git checkout -b feat/nova-funcionalidade`).
- Siga o estilo de código existente e adicione comentários se necessário.
- Certifique-se de que sua alteração não quebra o instalador principal (`install.sh`).
- Abra um Pull Request detalhando suas mudanças.

## Estrutura de Código

Ao adicionar novos módulos ou perfis:
- **Módulos:** Devem ser independentes e colocados em `modules/`.
- **Perfis:** Devem ser scripts bash em `profiles/` que chamam funções de instalação.
- **Scripts:** Devem ser portáteis e seguir as convenções do framework.

## Código de Conduta

Seja respeitoso e profissional com todos os membros da comunidade. O CyberShell é um ambiente inclusivo e acolhedor.

---
Dúvidas? Sinta-se à vontade para abrir uma discussão no GitHub!
