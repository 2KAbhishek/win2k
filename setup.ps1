[CmdletBinding()]
param(
    [Alias('s')]
    [switch]$Symlinks
)

$ErrorActionPreference = 'Stop'

$repoRoot = $PSScriptRoot
$documents = [Environment]::GetFolderPath('MyDocuments')
$scoopRoot = if ($env:SCOOP) { $env:SCOOP } else { Join-Path $env:USERPROFILE 'scoop' }

if (-not $Symlinks) {
    scoop config aria2-warning-enabled false | Out-Null
    if (-not (scoop bucket list 2>$null | Select-String -SimpleMatch "extras" -Quiet)) {
        scoop bucket add extras
    }

    # Scoop Packages (gow is first so that later package installs overwrite the shims)
    $apps = @(
        'gow', '7zip', 'aria2', 'bat', 'delta', 'eza', 'fd', 'fzf', 'gcc', 'gh', 'git',
        'glazewm', 'jq', 'lazygit', 'mise', 'neovim', 'nodejs', 'oh-my-posh', 'openssh',
        'powertoys', 'python', 'ripgrep', 'tree-sitter', 'vifm', 'winget', 'windows-terminal',
        'win32yank', 'zebar'
    )
    $scoopAppsDir = Join-Path $scoopRoot 'apps'
    $installedApps = @(Get-ChildItem -Path $scoopAppsDir -Directory -ErrorAction SilentlyContinue | Where-Object {
        (Test-Path (Join-Path $_.FullName 'current\install.json')) -or
        (Test-Path (Join-Path $_.FullName 'current\scoop-install.json'))
    } | ForEach-Object { $_.Name })
    $appsToInstall = $apps | Where-Object { $_ -notin $installedApps }

    if ($appsToInstall) {
        scoop install $appsToInstall
    }

    # Quietly update available apps (silencing noisy in-use process locks on stderr)
    scoop update * 2>$null

    # Fetch submodules
    git -C $repoRoot submodule update --init --recursive

    # Install Font
    oh-my-posh font install FiraCode

    # Install neovim helper quietly
    pip install neovim --quiet

    # PowerShell Modules (only install if missing or outdated to prevent file-lock warnings)
    if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
        Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
    }
    if (-not (Get-Module -ListAvailable -Name z)) {
        Install-Module -Name z -Scope CurrentUser -Force -AllowClobber
    }
    if (-not (Get-Module -ListAvailable -Name PSFzf)) {
        Install-Module -Name PSFzf -Scope CurrentUser -Force -AllowClobber
    }
    $psrl = Get-Module -ListAvailable -Name PSReadLine | Sort-Object Version -Descending | Select-Object -First 1
    if (-not $psrl -or $psrl.Version -lt [version]'2.2.0') {
        try {
            Install-Module -Name PSReadLine -Repository PSGallery -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber -ErrorAction Stop
        } catch {
            Write-Warning "PSReadLine could not be updated (likely in use by current session): $_"
        }
    }

    Update-Module -ErrorAction SilentlyContinue
}

New-Item -ItemType SymbolicLink -Path (Join-Path $documents 'WindowsPowerShell') -Target (Join-Path $repoRoot 'config\PowerShell') -Force

# PowerShell 7
New-Item -ItemType SymbolicLink -Path (Join-Path $documents 'PowerShell') -Target (Join-Path $repoRoot 'config\PowerShell') -Force

# posh2k
New-Item -ItemType SymbolicLink -Path (Join-Path $documents 'posh2k') -Target (Join-Path $repoRoot 'config\posh2k') -Force

# Terminal
$wtSettings = Join-Path $scoopRoot 'apps\windows-terminal\current\settings\settings.json'
if (Test-Path -LiteralPath $wtSettings) { Remove-Item -LiteralPath $wtSettings -Force }
New-Item -ItemType SymbolicLink -Path $wtSettings -Target (Join-Path $repoRoot 'config\Terminal\settings.json')

# GlazeWM and Zebar
New-Item -ItemType SymbolicLink -Path (Join-Path $env:USERPROFILE '.glzr') -Target (Join-Path $repoRoot 'config\glzr') -Force

# lazygit
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\lazygit" -Target (Join-Path $repoRoot 'dots2k\config\lazygit') -Force

# Config
$configPaths = @(
    "alacritty", "bat", "bundle", "cmus", "git", "htop", "kitty",
    "mise", "python", "ranger", "readline", ".ripgreprc", "shell",
    "topgrade.toml", "vim"
)

foreach ($configPath in $configPaths) {
    $source = Join-Path $repoRoot "dots2k\config\$configPath"
    $destination = Join-Path $env:USERPROFILE ".config\$configPath"
    New-Item -ItemType SymbolicLink -Path $destination -Target $source -Force
}

# Home
$homePaths = @(
    ".bashrc", ".dircolors", ".luarc.json", ".prettierrc",
    ".pryrc", ".stylua.toml", ".Xresources"
)

foreach ($homePath in $homePaths) {
    $source = Join-Path $repoRoot "dots2k\config\$homePath"
    $destination = Join-Path $env:USERPROFILE $homePath
    New-Item -ItemType SymbolicLink -Path $destination -Target $source -Force
}

# Vim on Windows doesn't natively check ~/.config/vim/vimrc, so we symlink .vimrc and _vimrc
New-Item -ItemType SymbolicLink -Path (Join-Path $env:USERPROFILE '.vimrc') -Target (Join-Path $repoRoot 'dots2k\config\vim\vimrc') -Force

