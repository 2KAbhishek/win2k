# File for Current User, Current Host - $PROFILE.CurrentUserCurrentHost

# Setup cache directory
$cacheDir = Join-Path $HOME ".cache/shell_init"
if (-not (Test-Path -Path $cacheDir)) {
    New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null
}

# Reusable caching initializer function
function Invoke-CachedInit {
    param (
        [string]$Tool,
        [string]$CacheFile,
        [string]$InitCmd,
        [string]$ConfigFile
    )

    $cachePath = Join-Path $cacheDir $CacheFile
    $rebuild = $false

    if (-not (Test-Path -Path $cachePath)) {
        $rebuild = $true
    } elseif ($ConfigFile -and (Test-Path -Path $ConfigFile)) {
        $cacheTime = (Get-Item $cachePath).LastWriteTime
        $configTime = (Get-Item $ConfigFile).LastWriteTime
        if ($configTime -gt $cacheTime) {
            $rebuild = $true
        }
    }

    if ($rebuild -and (Get-Command $Tool -ErrorAction SilentlyContinue)) {
        Invoke-Expression $InitCmd | Out-File -FilePath $cachePath -Encoding utf8
    }

    if (Test-Path -Path $cachePath) {
        . $cachePath
    }
}

$ompConfig = Join-Path $HOME "Documents/posh2k/posh2k.toml"
Invoke-CachedInit -Tool "oh-my-posh" -CacheFile "oh-my-posh.ps1" -InitCmd "oh-my-posh init pwsh --config '$ompConfig'" -ConfigFile $ompConfig
Invoke-CachedInit -Tool "mise" -CacheFile "mise.ps1" -InitCmd "mise activate pwsh"

# Cleanup namespace
Remove-Item Function:\Invoke-CachedInit -ErrorAction SilentlyContinue

# Async init queue: defers heavy module loads until after the prompt appears
[System.Collections.Queue]$global:__initQueue = @(
    { Import-Module -Name Terminal-Icons -Global },
    {
        Import-Module -Name PSFzf -Global
        Set-PSFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'
    }
)

Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -SupportEvent -Action {
    if ($__initQueue.Count -gt 0) {
        & $__initQueue.Dequeue()
    } else {
        Unregister-Event -SubscriptionId $EventSubscriber.SubscriptionId -Force
        Remove-Variable -Name '__initQueue' -Scope Global -Force
    }
}

$localPwsh = Join-Path $PSScriptRoot 'local.ps1'
if (Test-Path -LiteralPath $localPwsh) {
    . $localPwsh
}
