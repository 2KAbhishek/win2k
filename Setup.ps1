# Scoop
scoop bucket add anderlli0053_DEV-tools https://github.com/anderlli0053/DEV-tools
scoop install winget powershell oh-my-posh 7zip ag bat delta exa fasd fd fzf gh git gzip lazygit less lsd msys ntop navi openssh ripgrep vifm wget nodejs16 python

# Powershell
cp ~/Projects/Winfiles/PowerShell/* ~/Documents/WindowsPowerShell/ # PowerShell 5.1
cp ~/Projects/Winfiles/PowerShell/* ~/Documents/PowerShell/ #PowerShell 7
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Install-Module -Name z -Force -AllowClobber
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
Install-Module -Name PSFzf -Scope CurrentUser -Force

# Terminal
cp ~/Projects/Winfiles/Terminal/* ~/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/
