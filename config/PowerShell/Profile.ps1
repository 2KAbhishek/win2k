# Environment
$env:EDITOR = "nvim"

# File for Current User, All Hosts - $PROFILE.CurrentUserAllHosts
function Bash-Alias([string]$name, [string]$command) {
    try {
        $sb = [scriptblock]::Create($command)
    } catch {
        $cmd = $command -replace '\s*@args\s*$', '' -replace '\$(?!env:|\()(\w+)', '$env:$1'
        if ($cmd -match '^"') { $cmd = "& $cmd" }
        try { $sb = [scriptblock]::Create($cmd) } catch { return }
    }
    New-Item "Function:\global:$name" -Value $sb -Force | Out-Null
}

# Get-Property
Del alias:gp -Force
# Get-Location
Del alias:gl -Force
# Get-Content
Del alias:gc -Force

. "$PSScriptRoot\aliases.gen.ps1"

Bash-Alias p2k "nvim $env:HOMEPATH\Documents\posh2k\posh2k.omp.json"
Bash-Alias pwshc "nvim $env:HOMEPATH\Documents\PowerShell\Profile.ps1"
Bash-Alias loca "nvim $env:USERPROFILE\local.ps1"
Bash-Alias reload ". $PROFILE"

Bash-Alias sci "scoop install @args"
Bash-Alias scr "scoop uninstall @args"
Bash-Alias scs "scoop search @args"
Bash-Alias scu "scoop update *"

function RMF([string]$path) { Remove-Item -Recurse -Force $path }

# Modules
Import-Module Terminal-Icons

# PSReadLine
Set-PSReadLineOption -BellStyle None
$psReadLineVt = $false
if ($Host.UI.PSObject.Properties.Match('SupportsVirtualTerminal').Count -gt 0) {
    $psReadLineVt = $Host.UI.SupportsVirtualTerminal
}
if ([Environment]::UserInteractive -and $psReadLineVt) {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
}

# PSFzf
Set-PSFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'
