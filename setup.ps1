# Scoop Packages
scoop bucket add anderlli0053_DEV-tools https://github.com/anderlli0053/DEV-tools
scoop install winget powershell oh-my-posh powertoys 7zip ag bat delta exa fasd `
fd fzf gh git gzip lazygit less lsd make msys ntop navi openssh ripgrep vifm wget nodejs16 python

scoop update *

Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
Install-Module -Name z -Scope CurrentUser -Force -AllowClobber
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
Install-Module -Name PSFzf -Scope CurrentUser -Force -AllowClobber

Update-Module -Scope CurrentUser

# Powershell
cmd /c mklink /d %HOMEPATH%\Documents\WindowsPowerShell %CD%\config\PowerShell\
# Powershell 7
cmd /c mklink /d %HOMEPATH%\Documents\PowerShell\ %CD%\config\PowerShell\

cmd /c mklink /d %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\ %CD%\config\Terminal\

# Fetch submodules
git submodule update --init

cmd /c mklink /d %LOCALAPPDATA%\nvim %CD%\config\nvim2k\
cmd /c mklink /d %HOMEPATH%\Documents\Posh2K %CD%\config\Posh2K\
