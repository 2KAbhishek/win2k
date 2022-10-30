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

Bash-Alias .. "cd .."
Bash-Alias ga "git add @args"
Bash-Alias gc "git commit -m @args"
Bash-Alias gcam "git commit -a -m @args"
Bash-Alias gg "lazygit"
Bash-Alias ghrc "gh repo clone @args"
Bash-Alias gl "git pull"
Bash-Alias glog "git log"
Bash-Alias gp "git push"
Bash-Alias gss "git status -s"
Bash-Alias q "exit"
Bash-Alias sci "scoop install @args"
Bash-Alias scr "scoop uninstall @args"
Bash-Alias scu "scoop update @args"
Bash-Alias vi "nvim @args"

# Modules
Import-Module Terminal-Icons

# PSReadLine
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# PSFzf
Set-PSFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'

