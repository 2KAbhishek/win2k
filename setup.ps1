# Scoop Packages
scoop bucket add anderlli0053_DEV-tools https://github.com/anderlli0053/DEV-tools
scoop install winget powershell oh-my-posh powertoys 7zip ag bat delta eza zoxide komorebi whkd `
fd fzf gh git gzip lazygit less lsd make msys ntop navi openssh ripgrep vifm wget nodejs python

scoop update *

Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
Install-Module -Name z -Scope CurrentUser -Force -AllowClobber
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
Install-Module -Name PSFzf -Scope CurrentUser -Force -AllowClobber

Update-Module

# Fetch submodules
git submodule update --init --recursive

# PowerShell
New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\Documents\WindowsPowerShell" -Target "$PWD\config\PowerShell" -Force

# PowerShell 7
New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\Documents\PowerShell" -Target "$PWD\config\PowerShell" -Force

# posh2k
New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\Documents\posh2k" -Target "$PWD\config\posh2k" -Force

# Terminal
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -Target "$PWD\config\Terminal" -Force

# Komorebi
New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\.config\komorebi" -Target "$PWD\config\komorebi" -Force
New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\.config\whkdrc" -Target "$PWD\config\whkdrc" -Force

# lazygit
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\lazygit" -Target "$PWD\dots2k\config\lazygit" -Force

# Config
$toolPaths = @(
    "bat", "broot", "bundle", "cmus", "delta", "fish", "gitignore.global",
    "htop", "kitty", "ranger", "shell", "topgrade.toml", "xplr"
)

foreach ($toolPath in $toolPaths) {
    $source = Join-Path $PWD "dots2k\config\$toolPath"
    $destination = Join-Path $env:USERPROFILE ".config\$toolPath"
    New-Item -ItemType SymbolicLink -Path $destination -Target $source -Force
}

# Home
$homePaths = @(
    ".bashrc", ".dircolors", ".gitconfig", ".inputrc", ".luarc.json", ".prettierrc", ".pryrc",
    ".pystartup", ".stylua.toml", ".tmux.conf", ".vimrc", ".Xresources", ".zshrc"
)

foreach ($homePath in $homePaths) {
    $source = Join-Path $PWD "dots2k\config\$homePath"
    $destination = Join-Path $env:USERPROFILE $homePath
    New-Item -ItemType SymbolicLink -Path $destination -Target $source -Force
}

