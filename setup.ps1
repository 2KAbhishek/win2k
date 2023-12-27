# Scoop Packages
scoop bucket add anderlli0053_DEV-tools https://github.com/anderlli0053/DEV-tools
scoop install neovim eza fd fzf ripgrep vifm bat less gh git lazygit delta make gcc msys2`
openssh wget nodejs python powershell powertoys winget oh-my-posh 7zip gzip komorebi whkd

scoop update *

Install-Module -Name Terminal-Icons -Repository PSGallery -Force -AllowClobber
Install-Module -Name z -Force -AllowClobber
Install-Module -Name PSReadLine -Force -SkipPublisherCheck -AllowClobber
Install-Module -Name PSFzf -Force -AllowClobber

Update-Module

# Fetch submodules
git submodule update --init --recursive

# Install Font
oh-my-posh font install FiraCode

# Install neovim helper
pip install neovim

# PowerShell
New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\Documents\WindowsPowerShell" -Target "$PWD\config\PowerShell" -Force

# PowerShell 7
New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\Documents\PowerShell" -Target "$PWD\config\PowerShell" -Force

# posh2k
New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\Documents\posh2k" -Target "$PWD\config\posh2k" -Force

# Terminal
Move-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -Destination "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState.bak" -Force
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -Target "$PWD\config\Terminal" -Force

# Komorebi
New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\.config\komorebi" -Target "$PWD\config\komorebi" -Force
New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\.config\whkdrc" -Target "$PWD\config\whkdrc" -Force

# lazygit
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\lazygit" -Target "$PWD\dots2k\config\lazygit" -Force

# Startup
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\startup.cmd" -Target "$PWD\config\startup.cmd" -Force

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

