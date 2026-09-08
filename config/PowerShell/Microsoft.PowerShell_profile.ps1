# File for Current User, Current Host - $PROFILE.CurrentUserCurrentHost

# Load local overrides first so we know what prompt type to load
$localPwsh = Join-Path $PSScriptRoot 'local.ps1'
if (Test-Path -LiteralPath $localPwsh) {
    . $localPwsh
}

# Load prompt based on UseLightPrompt setting
if ($global:UseLightPrompt) {
    . "$PSScriptRoot\Prompt.ps1"
}

# Async init queue: defers heavy module loads until after the prompt appears
[System.Collections.Queue]$global:__initQueue = @(
    {
        # Default is to use Oh My Posh, unless $global:UseLightPrompt is set to $true in local.ps1
        if (-not $global:UseLightPrompt) {
            oh-my-posh init pwsh --config "$HOME/Documents/posh2k/posh2k.toml" | Invoke-Expression
            [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
        }
    },
    { (&mise activate pwsh) | Out-String | Invoke-Expression },
    { Import-Module -Name Terminal-Icons -Global },
    { Import-Module -Name z -Global },
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
