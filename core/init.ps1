# cybershell loader for PowerShell
# Author: Manus AI

# --- VARIÁVEIS DE AMBIENTE ---
$env:CYBERSHELL_DIR = "$HOME/.config/cybershell"
$env:CYBERSHELL_STATE_DIR = "$env:CYBERSHELL_DIR/state"
$env:CYBERSHELL_THEME_FILE = "$env:CYBERSHELL_STATE_DIR/active_theme.txt"
$env:CURRENT_SHELL = "pwsh"

# --- CARREGAMENTO DO OH-MY-POSH ---
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    # Definir tema padrão se o arquivo de estado não existir
    if (!(Test-Path $env:CYBERSHELL_THEME_FILE)) { "tokyonight_storm" | Out-File $env:CYBERSHELL_THEME_FILE }
    
    $ACTIVE_THEME = Get-Content $env:CYBERSHELL_THEME_FILE
    
    # Tenta encontrar o tema no diretório do cybershell primeiro, depois no sistema
    $theme_path = "$env:CYBERSHELL_DIR/themes/$ACTIVE_THEME.omp.json"
    if (Test-Path $theme_path) {
        oh-my-posh init pwsh --config $theme_path | Invoke-Expression
    } else {
        # Fallback para temas padrão do oh-my-posh
        oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$ACTIVE_THEME.omp.json" | Invoke-Expression
    }
} else {
    # Prompt minimalista cyberpunk de fallback
    function prompt {
        Write-Host "[" -ForegroundColor Cyan -NoNewline
        Write-Host "cybershell" -ForegroundColor Magenta -NoNewline
        Write-Host "] " -ForegroundColor Cyan -NoNewline
        Write-Host "$($executionContext.SessionState.Path.CurrentLocation)" -ForegroundColor White -NoNewline
        Write-Host " ❯ " -ForegroundColor Green -NoNewline
        return " "
    }
}

# --- ALIASES E FUNÇÕES ---
# O comando 'cyber' agora é global via /usr/local/bin/cyber
Set-Alias -Name ls -Value Get-ChildItem

# --- CARREGAMENTO DE MÓDULOS ---
if (Test-Path "$env:CYBERSHELL_DIR/modules") {
    $modules = Get-ChildItem -Path "$env:CYBERSHELL_DIR/modules" -Filter *.ps1
    foreach ($module in $modules) {
        . $module.FullName
    }
}
