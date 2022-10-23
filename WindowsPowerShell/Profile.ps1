# File for Current User, All Hosts - $PROFILE.CurrentUserAllHosts
function Bash-Alias([string]$name, [string]$command) {
    $sb = [scriptblock]::Create($command)
    New-Item "Function:\global:$name" -Value $sb | Out-Null
}

function RMF([string]$path) { Remove-Item -Recurse -Force $path }

# Get-Property
Del alias:gp -Force
# Get-Location
Del alias:gl -Force

Bash-Alias ga "git add @args"
Bash-Alias gc "git commit -m @args"
Bash-Alias gp "git push"
Bash-Alias gl "git pull"
Bash-Alias gss "git status -s"
Bash-Alias glog "git log"
Bash-Alias .. "cd .."
Bash-Alias gcam "git commit -a -m @args"
