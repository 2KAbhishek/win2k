$ErrorActionPreference = 'Stop'

# Scoop Packages
$repoRoot = $PSScriptRoot
$documents = [Environment]::GetFolderPath('MyDocuments')

scoop config aria2-warning-enabled false
scoop bucket add anderlli0053_DEV-tools https://github.com/anderlli0053/DEV-tools
scoop install neovim eza fd fzf ripgrep vifm bat less gh git lazygit delta make msys2 openssh wget curl nodejs python powertoys winget oh-my-posh aria2 7zip gzip glazewm zebar gcc win32yank

scoop update *

# Fetch submodules
git -C $repoRoot submodule update --init --recursive

# Install Font
oh-my-posh font install FiraCode

# Install neovim helper
pip install neovim

# PowerShell
New-Item -ItemType SymbolicLink -Path (Join-Path $documents 'WindowsPowerShell') -Target (Join-Path $repoRoot 'config\PowerShell') -Force

# PowerShell 7
New-Item -ItemType SymbolicLink -Path (Join-Path $documents 'PowerShell') -Target (Join-Path $repoRoot 'config\PowerShell') -Force

# posh2k
New-Item -ItemType SymbolicLink -Path (Join-Path $documents 'posh2k') -Target (Join-Path $repoRoot 'config\posh2k') -Force

Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
Install-Module -Name z -Scope CurrentUser -Force -AllowClobber
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
Install-Module -Name PSFzf -Scope CurrentUser -Force -AllowClobber

Update-Module

# Terminal
Move-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -Destination "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState.bak" -Force
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -Target (Join-Path $repoRoot 'config\Terminal') -Force

# GlazeWM and Zebar
New-Item -ItemType SymbolicLink -Path (Join-Path $env:USERPROFILE '.glzr') -Target (Join-Path $repoRoot 'config\glzr') -Force

# lazygit
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\lazygit" -Target (Join-Path $repoRoot 'dots2k\config\lazygit') -Force

# Config
$toolPaths = @(
    "bat", "bundle", "cmus", "delta", "gitignore.global", "htop",
    "alacritty", "kitty", "ranger", "shell", "topgrade.toml"
)

foreach ($toolPath in $toolPaths) {
    $source = Join-Path $repoRoot "dots2k\config\$toolPath"
    $destination = Join-Path $env:USERPROFILE ".config\$toolPath"
    New-Item -ItemType SymbolicLink -Path $destination -Target $source -Force
}

# Home
$homePaths = @(
    ".bashrc", ".dircolors", ".gitconfig", ".inputrc", ".luarc.json",
    ".prettierrc", ".pryrc", ".pystartup", ".stylua.toml", ".vimrc", ".Xresources"
)

foreach ($homePath in $homePaths) {
    $source = Join-Path $repoRoot "dots2k\config\$homePath"
    $destination = Join-Path $env:USERPROFILE $homePath
    New-Item -ItemType SymbolicLink -Path $destination -Target $source -Force
}

