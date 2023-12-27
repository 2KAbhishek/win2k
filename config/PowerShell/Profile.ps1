# File for Current User, All Hosts - $PROFILE.CurrentUserAllHosts
function Bash-Alias([string]$name, [string]$command) {
    $sb = [scriptblock]::Create($command)
    New-Item "Function:\global:$name" -Value $sb | Out-Null
}

# Show path to executable
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function RMF([string]$path) { Remove-Item -Recurse -Force $path }

# Get-Property
Del alias:gp -Force
# Get-Location
Del alias:gl -Force
# Get-Content
Del alias:gc -Force

Bash-Alias .. "cd ../"
Bash-Alias ... "cd ../../"
Bash-Alias .... "cd ../../../"
Bash-Alias ..... "cd ../../../../"
Bash-Alias ga "git add @args"
Bash-Alias gc "git commit -m @args"
Bash-Alias gcam "git commit -a -m @args"
Bash-Alias gcm "git checkout main"
Bash-Alias gcma "git commit --amend -m @args"
Bash-Alias gcman "git commit --amend --no-edit"
Bash-Alias gdh "git diff HEAD"
Bash-Alias gg "lazygit"
Bash-Alias ghpc "gh pr create"
Bash-Alias ghrc "gh repo clone @args"
Bash-Alias ghrd "gh repo edit -d @args"
Bash-Alias ghrh "gh repo edit -h @args"
Bash-Alias ghrr "gh repo rename @args"
Bash-Alias ghrs "gh release create"
Bash-Alias ghrt "gh repo edit --add-topic @args"
Bash-Alias ghrv "gh repo edit --visibility "
Bash-Alias gl "git pull --rebase --autostash"
Bash-Alias glog "git log"
Bash-Alias gmv "git mv @args"
Bash-Alias gp "git push"
Bash-Alias grhh "git reset --hard HEAD"
Bash-Alias gss "git status -s"
Bash-Alias gsv "git status -v"
Bash-Alias gtop 'cd "$(git rev-parse --show-toplevel)"'
Bash-Alias la "ls"
Bash-Alias ll "ls"
Bash-Alias me "nvim README.md"
Bash-Alias p2k "nvim $env:HOMEPATH\Documents\posh2k\posh2k.omp.json"
Bash-Alias pwshrc "nvim $env:HOMEPATH\Documents\PowerShell\Profile.ps1"
Bash-Alias q "exit"
Bash-Alias sci "scoop install @args"
Bash-Alias scr "scoop uninstall @args"
Bash-Alias scs "scoop search @args"
Bash-Alias scu "scoop update *"
Bash-Alias vi "nvim @args"
Bash-Alias wgi "winget install @args"
Bash-Alias wgr "winget uninstall @args"
Bash-Alias wgs "winget search @args"
Bash-Alias wgu "winget upgrade -all "

# Modules
Import-Module Terminal-Icons

# PSReadLine
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# PSFzf
Set-PSFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'

