# File for Current User, Current Host - $PROFILE.CurrentUserCurrentHost

# Async init queue: defers heavy module loads until after the prompt appears
[System.Collections.Queue]$global:__initQueue = @(
    {
        oh-my-posh init pwsh --config "$HOME/Documents/posh2k/posh2k.toml" | Invoke-Expression
        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    },
    {
        Import-Module -Name PSFzf -Global
        Set-PSFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'
    },
    {
        Import-Module -Name Terminal-Icons -Global
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

$localPwsh = Join-Path $env:USERPROFILE 'local.ps1'
if (Test-Path -LiteralPath $localPwsh) {
    . $localPwsh
}
